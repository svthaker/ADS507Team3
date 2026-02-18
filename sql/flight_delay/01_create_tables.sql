-- 01_create_tables.sql
-- database + pipeline tables you need to run this first

CREATE DATABASE IF NOT EXISTS ads507;
USE ads507;

-- Drop in dependency order
DROP VIEW IF EXISTS airline_delay_summary;
DROP VIEW IF EXISTS route_delay_summary;
DROP VIEW IF EXISTS daily_delay_trend;

DROP TABLE IF EXISTS flights_clean;
DROP TABLE IF EXISTS flights_raw;

-- Raw table (typed)
CREATE TABLE IF NOT EXISTS flights_raw (
    FL_DATE DATE,
    AIRLINE VARCHAR(50),
    ORIGIN  VARCHAR(10),
    DEST    VARCHAR(10),
    DEP_DELAY INT,
    ARR_DELAY INT,
    CANCELLED INT
);

CREATE TABLE IF NOT EXISTS flights_clean (
    flight_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    flight_date DATE,
    airline VARCHAR(50),
    origin VARCHAR(10),
    dest VARCHAR(10),
    departure_delay INT,
    arrival_delay INT,
    cancelled_flag INT
);

-- Indexes that may be helpful 
CREATE INDEX idx_flight_date ON flights_clean(flight_date);
CREATE INDEX idx_airline     ON flights_clean(airline);
CREATE INDEX idx_route       ON flights_clean(origin, dest);
CREATE INDEX idx_cancelled   ON flights_clean(cancelled_flag);


CREATE TABLE IF NOT EXISTS pipeline_run_log (
    run_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dataset_code VARCHAR(20),
    step_name VARCHAR(50),
    run_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    row_count INT,
    status VARCHAR(20),
    notes VARCHAR(255)
);
