# ADS 507 Final Project – Team 3

## Project Overview

This repository contains our fully reproducible data pipeline for analyzing multiple aviation-related datasets:

1. Flight Delay and Cancellation Dataset (2019–2023)
2. US 2023 Civil Flights (delays, meteorological, and aircraft data)
3. Historical Flight Delay and Weather Data (USA)

The pipeline ingests raw CSV files, loads them into a persistent MySQL database, performs SQL transformations, and produces analytics-ready tables and summary views.

---

## Repository Structure

```
sql/
  flight_delay/
  civil_flights/
  aircraft/
docs/
README.md
```

Each dataset folder contains scripts for:

- Table creation  
- Data ingestion  
- Data transformation  
- View creation  
- Monitoring  

---

## Persistent Data Store

All data is stored in a MySQL database named:

ads507 (bsanchez)

Core pipeline tables include:

- flights_raw  
- flights_clean  
- pipeline_run_log  

Additional raw and clean tables are created for weather and aircraft datasets. (Shrey + Shivam to adD)

---

## How to Deploy the Pipeline

### Step 1 – Create the Database

```sql
CREATE DATABASE IF NOT EXISTS ads507;
USE ads507;
```

### Step 2 – Load Raw Data

Load CSV files into staging tables using either:

- MySQL Workbench Table Data Import Wizard  
OR  
- LOAD DATA LOCAL INFILE  

Example:

```sql
LOAD DATA LOCAL INFILE '/path/to/file.csv'
INTO TABLE staging_table
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

### Step 3 – Run SQL Scripts in Order

1. 01_create_tables.sql  
2. 02_ingest.sql  
3. 03_transform.sql  
4. 04_views.sql  
5. 05_monitoring.sql  

---

## SQL Transformations

The pipeline performs:

- Data type conversion using STR_TO_DATE  
- Null handling using COALESCE  
- Data normalization using TRIM  
- Aggregations for analytical summary views  

Example transformation:

```sql
INSERT INTO flights_clean (...)
SELECT
    STR_TO_DATE(FL_DATE, '%Y-%m-%d'),
    TRIM(AIRLINE),
    TRIM(ORIGIN),
    TRIM(DEST),
    COALESCE(DEP_DELAY, 0),
    COALESCE(ARR_DELAY, 0),
    COALESCE(CANCELLED, 0)
FROM flights_raw;
```

---

## Output

The pipeline produces analytics-ready summary views including:

- Airline delay performance  
- Route delay analysis  
- Daily delay trends  
- Weather impact analysis  
- Aircraft comparisons  

---

## Monitoring

Pipeline execution is logged in:

pipeline_run_log

Check latest pipeline run:

```sql
SELECT *
FROM pipeline_run_log
ORDER BY run_id DESC
LIMIT 5;
```

Basic health checks:

```sql
SELECT COUNT(*) FROM flights_raw;
SELECT COUNT(*) FROM flights_clean;
```

---

## System Architecture

CSV Files  
↓  
Staging Tables  
↓  
Raw Tables  
↓  
Clean Tables  
↓  
Analytical Views  

---

## Limitations

- Manual CSV ingestion step (documented)  
- No automated scheduler implemented  
- Currently deployed in local MySQL environment  

---

## Future Improvements

- Automate ingestion using Python  
- Containerize with Docker  
- Add CI/CD via GitHub Actions  
- Deploy to cloud database infrastructure  

---

## Team Members

- Shivam Patel
- Brianna Sanchez  
- Shrey Thaker
- ADS 507 – Team 3
