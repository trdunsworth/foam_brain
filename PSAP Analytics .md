# PSAP Analytics 

## Infrastructure

I think that this should all be built in a Docker container or something similar that can be deployed as an all-in-one solution.

Right now, I recommend a Python environment. My default is 3.13 at this point. Python has been chosen over R because I expect that more potential users will have expereince with Python over R or Julia. This choice also will encourage customization by customers to ensure this is what they need.

Building the Python environment, I use uv because it really has simplified the process to the point that it is almost trivial.

```bash
cd ~/projects

uv init project_name

cd project_name

uv venv

source .venv/bin/activate
```

Violá, you're done. Now everything is set up.

This leaves you a file structure that should be updated to look like this:

```
.
├── .venv/
|-- data/
├── docs/
│   ├── setup.md
│   ├── usage.md
│   └── README.md
├── src/
│   ├── main.py
│   └── utils.py
├── tests/
│   └── test_main.py
├── .gitignore
|__ pyproejct.toml
|-- uv.lock
└── LICENSE
```

After that is created, then I suggest adding in the libraries. Thankfully, that is relatively easy.

```bash
uv add pandas polars numpy scipy scikit-learn arrow seaborn matplotlib statsmodels plotly duckdb timecopilot ruff ty SQLAlchemy mssql-python boltons

uv lock
```

My choices can be explained below:

- **pandas**: This is the normal standard for creating dataframes. For this work, the standard *should* be enough. If you have a larger PSAP, like LA or NYC, then polars could be a better choice.
- **polars**: This is mainly for *much greater* data volume. *Most* PSAPS will never need this, but for a mega-centre, this could be handy to prevent slow down when crunching data.
- **numpy**: This is the defacto standard for mathematical operations for Python. If you extend my work, you're going to need it.
- **scipy**: This extends numpy with additional statistical and advanced mathematical functions. It is helpful for advanced statistical properties.
- **scikit-learn**: This library works for regression and other advanced modeling options. It's easier to work with than TensorFlow or PyTorch, so it's a quicker go to library.
- **arrow**: Like lubridate for R, this can work with date & times. It can do that work in real language or in mathematical terms.
- **matplotlib**: This is the go to standard for python graphics.
- **seaborn**: This sits on top of and enhances matplotlib.
- **plotly**: I like this one better because it emphasizes the use of the Grammar of Graphics theory. This allows you to build more detailed graphics using a clear and consistent vocabulary. 
- **statsmodels**: This library gives additional statistical models for use in analyses.
- **duckdb**: I use this to process csv files or dataframes and use a SQL dialect to ask questions about the data. This can also grab data from other sources and make dataframes from those.
- **timecopilot**: This is a zero-shot time forecasting library. For this project, this is going to be used to create some basic forecasts that can be embeded in reports.
- **ruff**: This is a Python linter that was developed by the same people that created uv. Linting files is a good way to ensure that your code is well-written and more safe/secure.
- **ty**: This library will help ensure type safety in the data. This will prevent issues by conversion with types.
- **SQLAlchemy**: This is an ORM that can be used to draw data directly from a database and prepare it for use, programatically, in Python.
- **mssql-python**: This is a library and driver to access Microsoft SQL Server databases from Python.
- **boltons**: This library has a lot of functions that are not in basic Python, but should have been.

### Measurements
