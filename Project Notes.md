# Project Notes

## Date: 2026-04-14

### Synthetic 9-1-1 Data Generator v3

Project: Create the new version which will do a better job of creating tabular CAD data and datasets of synthetic call volume data.

Tech Stack: Python 3.12+ controlled by the Astral stack (uv, ruff, ty), faker, duckdb, numpy, scipy, json, parquet, arrow.

Goals: Create software that can do the following:

1. Simulate CAD incident data that consists of:
   - Id number
   - Internal Reference number
   - Agency
   - Problem Nature
   - Priority
   - Location *address with directionals, city, and state* ***prefer these to be real addresses***
   - Datetime that the call starts
   - Times throughout the call life cycle *received, in-queue, dispatched, acknowledges, en-route, arrived, closed*
   - Calltaker and Dispatcher
   - Time point breakdowns for classification
2. Simulate hourly centre call counts of:
   - 9-1-1 calls received
   - 9-1-1 calls abandoned
   - non-emergency calls received
   - non-emergency calls abandoned
   - outbound calls placed
3. Ensure that all distributions are accurate and realistic
4. Export all datasets as csv, parquet, pandas dataframe, polar dataframe, JSON/YAML
5. Accessible through a TUI or a GUI depending on the users preference
6. Ensure that addresses are realistic through either [Open Street Map](https://www.openstreetmap.org/) and/or [QGIS](https://qgis.org/)  
7. Capapble of scaling to generate from hundreds to millions of rows of data at a time.

### dunsworth-mann.com site

Project: Create a new static website for DMA to illustrate and advertise our services. 

Tech Stack: deno, vite, fresh, tailwind, typescript, markdown.

links to tech stack:

- [Deno](https://deno.com/)
- [Deno Docs](https://docs.deno.com/runtime/)
- [Fresh](https://fresh.deno.dev/)
- [Fresh Docs](https://fresh.deno.dev/docs/getting-started)
- [Vite](https://vite.dev/)
- [Vite Docs](https://vite.dev/guide/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Tailwind Docs](https://tailwindcss.com/docs/installation/using-vite)

Goals: Get the site developed, using previously selected assets, and get it deployed to the domain host to start promoting the business.

Pages Needed: 

1. Landing page
2. About us
3. Our Services 
4. Possible Blog  in future
5. Where we have presented

### NENA survey site

Project: Create a site for the Staffing Guidelines and Call Proc working groups.

Tech Stack: node, react, vite, typescript, markdown, postgres

Goals: Create and deploy the survey to collect PSAP demographic information for the two working groups. Additionally, demonstrate the need for a data sience position in NENA to ensure they stay the 9-1-1 industry leader.

### DECC Reporting blog

Project: Create a blog that can deliver reports to DECC regarding their weekly/monthly statistics.

Tech Stack: Python 3.12, quarto, pandas, numpy, scipy, arrow, jupyter

Goals: Create a self-sustaining reporting system that can be accessed through a simple markdown interface. The project needs to update to select the most recent files, but also maintain the data links for previous reports.

### Dr. D Blog and Podcast

Project: Continue the blog and start adding multimedia content.

Tech Stack: R, Quarto, Markdown.

Goal: This is my personal blog where I discuss what I want. I plan on contiuing to promote data usage and analytics in the 9-1-1 industry overall.

### Staffing Algorithm

Project: Develop a better staffing algorithm for 9-1-1 centres.

Tech Stack: Python 3.12+ controlled by the Astral stack (uv, ruff, ty), duckdb, timecopilot, Nixtla Time_GPT, pyarrow, game theory, queueing theory.

Goals:

1. Develop a better forecasting system for 9-1-1 call volume data.
2. Analyse trends through the introduction of exogenous factors.
3. Determine how game theory and Queueing theory can intersect to model actual customer access behaviour.
