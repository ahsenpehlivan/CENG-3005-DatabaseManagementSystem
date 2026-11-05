# Pipeline Incident Database

![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?logo=mysql&logoColor=white) ![Python](https://img.shields.io/badge/Python-Data%20Loader-3776AB?logo=python&logoColor=white)

A database coursework project that models pipeline incident records and supports analysis of locations, operators, causes, impacts, and costs. It combines a normalized MySQL schema with SQL views, stored procedures, sample queries, and a Python CSV loader.

## What is in the repository

| File | Purpose |
| --- | --- |
| [`pipline_db_ddl.sql`](pipline_db_ddl.sql) | Table definitions and relationships for the incident database |
| [`pipline_db_views.sql`](pipline_db_views.sql) | Summaries by state, operator cost, and cause category |
| [`pipline_db_storeProcedure.sql`](pipline_db_storeProcedure.sql) | Operator annual summary procedure |
| [`pipline_report_sql_questions.sql`](pipline_report_sql_questions.sql) | Analysis queries used for the coursework report |
| [`data_loader.py`](data_loader.py) | Loads the CSV dataset into a local MySQL database |
| [`PehlivanOzdenKilli.pdf`](PehlivanOzdenKilli.pdf) | Project report |

## Explore locally

Use a local MySQL 8 instance to inspect the schema and SQL queries. The Python loader uses `pandas`, `numpy`, and `mysql-connector-python` and reads `database_renew.csv` from the repository root.

**Before running the loader:** review its connection settings and use a disposable local database. The script drops and recreates the `pipline_db` schema.

> Academic project for database design and SQL practice; it is not a production data service.
