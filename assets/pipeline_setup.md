# Modern Analytics Pipeline: SQL Server to DuckDB via dbt-duckdb

This document outlines the architecture, setup requirements, and codebase necessary to replace a monolithic T-SQL script with a high-performance, decoupled ELT pipeline utilizing `connectorx`, `pyarrow`, `dbt-duckdb`, and `Quarto`.

---

## 1. Development Environment & Package Management

### Recommended Toolchain

* **Python Version:** `3.13` (Current stable performance standard, offering superior memory isolation and execution speeds).
* **Package Manager:** `uv` by Astral (Blazing fast Rust-based dependency manager and lockfile engine).

### `pyproject.toml`

Create this file at the root of your project directory (`analytics_repo/pyproject.toml`). It is configured to allow `uv` to instantiate your virtual environment and resolve dependencies immediately.

```toml
[project]
name = "corporate-incident-analytics"
version = "1.0.0"
description = "High-performance ELT framework transferring raw data from SQL Server to localized DuckDB"
readme = "README.md"
requires-python = ">=3.12"
dependencies = [
    "connectorx>=0.4.0",
    "pyarrow>=15.0.0",
    "duckdb>=1.1.0",
    "dbt-core>=1.8.0",
    "dbt-duckdb>=1.8.0",
    "python-dotenv>=1.0.1",
]

[tool.uv]
managed = true
dev-dependencies = [
    "ruff>=0.4.0",
]

```

To initialize the environment using `uv`, run the following commands in your terminal:

```bash
# Initialize project environment
uv sync

# Activate the virtual environment
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

```

### R Prerequisites (For Quarto Report Consumption)

Run this inside your R console to establish the visualization and data layer components:

```R
install.packages(c("DBI", "duckdb", "ggplot2", "remotes"))
remotes::install_github("tomasreigl/ggsql") # Installs ggsql integration extension

```

---

## 2. Directory Structure

Ensure your repository layout follows this exact structure to guarantee relative file paths evaluate correctly:

```text
analytics_repo/
├── pyproject.toml
├── config.env
├── scripts/
│   └── ingest.py
├── dbt_project/
│   ├── dbt_project.yml
│   ├── profiles.yml
│   ├── macros/
│   │   └── parse_elapsed_time.sql
│   └── models/
│       ├── sources.yml
│       └── marts/
│           └── fct_incident_reporting.sql
└── reports/
    └── weekly_report.qmd

```

---

## 3. Extraction & Configuration Layer

### `config.env`

Store server-specific network strings here. Do not commit this file to version control.

```env
# Network configuration to production SQL Server 2019
DB_HOST=192.168.1.50
DB_PORT=1433
DB_NAME=Reporting_System
DB_USER=analytics_pipeline_user
DB_PASSWORD=your_secure_password_here

```

### `scripts/ingest.py`

This script executes over the network from your Analytics Server. It uses `connectorx` to stream raw rows straight into localized Apache Arrow memory spaces, bypassing Python's row-looping performance bottlenecks before converting to Parquet.

```python
import os
import connectorx as cx
import pyarrow.parquet as pq
from dotenv import load_dotenv

def run_network_extraction():
    # Load configuration
    load_dotenv(dotenv_path="config.env")
    
    # Construct high-performance connectorx connection URI
    conn_str = (
        f"mssql://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}"
        f"@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
        "?encrypt=true&trustServerCertificate=true"
    )

    # Targets to extract raw database items safely without doing processing on SQL Server
    queries = {
        "raw_rmi": "SELECT * FROM Response_Master_Incident",
        "raw_rmi_ext": "SELECT * FROM Response_Master_Incident_Ext",
        "raw_activity_log": "SELECT * FROM Activity_Log",
        "raw_personnel": "SELECT * FROM Personnel"
    }

    # Ensure targeted drop folder exists
    output_dir = "dbt_project/data/raw"
    os.makedirs(output_dir, exist_ok=True)

    for table_name, sql in queries.items():
        print(f"Executing high-speed extraction for: {table_name}...")
        
        # Bypasses Python GIL, outputs Apache Arrow Table object natively
        arrow_table = cx.read_sql(conn_str, sql, return_type="arrow")
        
        # Write directly to disk as snappy-compressed columnar parquet files
        output_path = os.path.join(output_dir, f"{table_name}.parquet")
        pq.write_table(arrow_table, output_path, compression="snappy")
        print(f"Successfully serialized {table_name}.parquet")

if __name__ == "__main__":
    run_network_extraction()

```

---

## 4. Transformation Layer (`dbt-duckdb`)

### `dbt_project/profiles.yml`

Configure dbt to target and build an independent local database file inside your reporting hierarchy.

```yaml
dbt_project:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: ../reports/prod_analytics.duckdb
      threads: 4

```

### `dbt_project/dbt_project.yml`

```yaml
name: 'dbt_project'
version: '1.0.0'
config-version: 2

profile: 'dbt_project'

model-paths: ["models"]
macro-paths: ["macros"]

models:
  dbt_project:
    marts:
      materialized: view # Views inside DuckDB process instantly and read directly from optimized files

```

### `dbt_project/models/sources.yml`

Map the raw parquet file drops directly as standard dbt source references.

```yaml
version: 2

sources:
  - name: raw_parquet
    meta:
      external_location: "../data/raw/{name}.parquet"
    tables:
      - name: raw_rmi
      - name: raw_rmi_ext
      - name: raw_activity_log
      - name: raw_personnel

```

### `dbt_project/macros/parse_elapsed_time.sql`

Replaces your legacy `dbo.fn_ParseElapsedTime` SQL Server function. This compiles directly into highly parallelized, native DuckDB text operations.

```sql
{% macro parse_elapsed_time(column_name) %}
CASE 
    WHEN {{ column_name }} IS NULL THEN NULL
    -- Format verification: check for HH:MM:SS pattern (2 colons present)
    WHEN LENGTH({{ column_name }}) - LENGTH(REPLACE({{ column_name }}, ':', '')) = 2 THEN
        CAST(SPLIT_PART({{ column_name }}, ':', 1) AS INT) * 3600 +
        CAST(SPLIT_PART({{ column_name }}, ':', 2) AS INT) * 60 +
        CAST(FLOOR(CAST(SPLIT_PART({{ column_name }}, ':', 3) AS FLOAT)) AS INT)
    -- Format verification: check for MM:SS pattern (1 colon present)
    WHEN LENGTH({{ column_name }}) - LENGTH(REPLACE({{ column_name }}, ':', '')) = 1 THEN
        CAST(SPLIT_PART({{ column_name }}, ':', 1) AS INT) * 60 +
        CAST(FLOOR(CAST(SPLIT_PART({{ column_name }}, ':', 2) AS FLOAT)) AS INT)
    ELSE NULL
END
{% endmacro %}

```

### `dbt_project/models/marts/fct_incident_reporting.sql`

The direct refactor of your complete T-SQL logic. DuckDB completely eliminates the multi-line procedural code by implementing native vector array optimizations (`LEAST`/`GREATEST`) and direct timestamp subtraction intervals.

```sql
WITH al_summary AS (
    SELECT 
        Master_Incident_ID,
        MIN(CASE WHEN Activity = 'Incident in Waiting Queue' THEN Date_Time END) AS First_Queue_Time,
        MIN(CASE WHEN Activity = 'Dispatched' THEN Date_Time END) AS First_Dispatch_Time,
        MIN(CASE WHEN Activity = 'En Route' THEN Date_Time END) AS First_Enroute_Time,
        MIN(CASE WHEN Activity = 'On Scene' THEN Date_Time END) AS First_OnScene_Time,
        MIN(CASE WHEN Activity = 'Response Closed' THEN Date_Time END) AS First_Closed_Time,
        MAX(CASE WHEN Activity = 'Response Closed' THEN Date_Time END) AS Final_Closed_Time,
        MIN(CASE WHEN Activity = 'Incident Reopen' THEN Date_Time END) AS First_Reopen_Time,
        MIN(CASE WHEN Activity = 'Dispatched' THEN Dispatcher_Init END) AS First_Dispatcher_Init
    FROM {{ source('raw_parquet', 'raw_activity_log') }}
    GROUP BY Master_Incident_ID
),

base_joined AS (
    SELECT 
        rmi.Master_Incident_Number,
        rmi.Response_Date,
        rmi.Agency_Type,
        rmi.Time_CallClosed,
        rmi.Fixed_Time_CallClosed,
        al.First_Closed_Time,
        al.First_Reopen_Time,
        al.Final_Closed_Time,
        p.Emp_Name AS Dispatcher_Name,
        
        -- Macro dynamic injection for parsing times
        {{ parse_elapsed_time('rmi.Elapsed_CallRcvd2InQueue') }} AS Elapsed_PS_Queue,
        {{ parse_elapsed_time('rmi.Elapsed_CallRcvd2CalTakDone') }} AS Elapsed_PS_CTD,
        
        -- DuckDB vectorized logic replaces complex SQL Server values subqueries
        LEAST(rmi.Response_Date, rmi.ClockStartTime, rmi.Time_PhonePickUp, rmi.Fixed_Time_PhonePickUp) AS Min_Start_Time,
        LEAST(rmi.Time_CallEnteredQueue, rmi.Fixed_Time_CallEnteredQueue, al.First_Queue_Time) AS Min_Queue_Time,
        LEAST(rmi.Time_CallClosed, rmi.Fixed_Time_CallClosed, al.First_Closed_Time) AS Min_Close_Time

    FROM {{ source('raw_parquet', 'raw_rmi') }} rmi
    INNER JOIN {{ source('raw_parquet', 'raw_rmi_ext') }} e ON rmi.ID = e.Master_Incident_ID
    LEFT JOIN al_summary al ON rmi.ID = al.Master_Incident_ID
    LEFT JOIN {{ source('raw_parquet', 'raw_personnel') }} p ON al.First_Dispatcher_Init = p.Emp_ID
    WHERE al.First_Dispatch_Time IS NOT NULL
)

SELECT 
    Master_Incident_Number,
    Response_Date,
    -- Format date tracking elements using standard clean string timestamp syntax
    STRFTIME(Response_Date, '%a') AS DOW,
    
    -- Reconstructed shift allocation logic
    CASE
        WHEN EXTRACT(WEEK FROM Response_Date) % 2 = 0 AND STRFTIME(Response_Date, '%a') IN ('Mon', 'Tue', 'Fri', 'Sat') THEN 
            CASE WHEN EXTRACT(HOUR FROM Response_Date) BETWEEN 6 AND 18 THEN 'A' ELSE 'C' END
        ELSE 'B'
    END AS [Shift],

    -- Direct epoch tracking interval subtraction
    CASE 
        WHEN Min_Queue_Time IS NOT NULL AND Min_Start_Time IS NOT NULL 
        THEN EPOCH(Min_Queue_Time - Min_Start_Time) 
        ELSE NULL 
    END AS Time_To_Queue,

    CASE 
        WHEN Min_Close_Time IS NOT NULL AND Min_Start_Time IS NOT NULL 
        THEN EPOCH(Min_Close_Time - Min_Start_Time) 
        ELSE NULL 
    END AS Total_Call_Time,

    CASE WHEN First_Reopen_Time IS NOT NULL THEN 1 ELSE 0 END AS Call_Reopened
FROM base_joined

```

---

## 5. Presentation Layer (Quarto Report)

### `reports/weekly_report.qmd`

This reporting document interfaces natively with the database compilation artifact. It uses `ggsql` to stream query transformations into analytical visuals using R, while maintaining cross-language access for Python components.

```markdown
---
title: "Incident Response Weekly Performance Metrics"
format: html
engine: knitr
---

```{r setup, message=FALSE, warning=FALSE, echo=FALSE}
library(DBI)
library(duckdb)
library(ggplot2)
library(ggsql)

# Attach to generated infrastructure database via safe concurrency mapping
con <- dbConnect(duckdb::duckdb(), dbdir = "prod_analytics.duckdb", read_only = TRUE)

```

## Response Metrics via Native R + ggsql

The visualization below references our compiled model directly within DuckDB, preventing overhead allocations from filling local system memory profiles.

```{r analytical-viz, fig.width=10, fig.height=5}
ggsql(con, "SELECT [Shift], AVG(Time_To_Queue) as avg_queue_sec FROM fct_incident_reporting GROUP BY [Shift]") +
  geom_col(aes(x = Shift, y = avg_queue_sec, fill = Shift)) +
  labs(title = "Average Queue Processing Interval by Shift Assignment",
       x = "Assigned Shift Team",
       y = "Mean Interval Duration (Seconds)") +
  theme_minimal()

```

## Python Modeling Sandbox Component

Data transitions between platforms cleanly over shared architectural pathways without needing flat file intermediary allocations.

```{python processing-engine, echo=TRUE}
import duckdb

# Connect to the exact same file cleanly using read_only file locks
con_py = duckdb.connect("prod_analytics.duckdb", read_only=True)

# Fetch data directly into a local Pandas DataFrame for modeling steps
df = con_py.execute("SELECT * FROM fct_incident_reporting").df()

print(f"DataFrame loaded successfully. Processed rows: {len(df)}")
# [Your advanced machine learning/forecasting code runs here]

```

```{r termination-step, echo=FALSE}
# Graceful disconnect of process infrastructure handles
dbDisconnect(con, shutdown = TRUE)

```

```

---

## 6. Execution Protocol

To trigger the updated workload sequentially, execute this string from the root project execution directory:

```bash
# 1. Pipeline extraction ingestion phase
python scripts/ingest.py

# 2. Re-compile models inside duckdb
cd dbt_project && dbt run --profiles-dir . && cd ..

# 3. Complete output analytical reports
quarto render reports/weekly_report.qmd

```
