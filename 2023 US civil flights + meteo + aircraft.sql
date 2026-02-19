-- renaming tables

RENAME TABLE `05-2019` TO may;
RENAME TABLE `06-2019` TO jun;
RENAME TABLE `07-2019` TO jul;
RENAME TABLE `08-2019` TO aug;
RENAME TABLE `09-2019` TO sep;
RENAME TABLE `10-2019` TO oct;
RENAME TABLE `11-2019` TO nov;
RENAME TABLE `12-2019` TO `dec`;

SHOW TABLES;

-- combining rows from each month into one table

CREATE TABLE all_flights
AS SELECT * FROM may
UNION ALL
SELECT * FROM jun
UNION ALL
SELECT * FROM jul
UNION ALL
SELECT * FROM aug
UNION ALL
SELECT * FROM sep
UNION ALL
SELECT * FROM oct
UNION ALL
SELECT * FROM nov
UNION ALL
SELECT * FROM `dec`;

DESCRIBE all_flights;
SELECT * FROM all_flights LIMIT 10;


-- cleaning combined table

CREATE TABLE all_flights_cleaned
AS SELECT
	ROW_NUMBER() OVER() AS flight_id,
    TRIM(carrier_code) AS carrier_code,
    TRIM(origin_airport) AS orig_airport,
    TRIM(destination_airport) AS dest_airport,
    TRIM(tail_number) AS tail_num,
    TRIM(STATION_x) AS station_x,
	TRIM(STATION_y) AS station_y,
    STR_TO_DATE(`date`, '%Y-%m-%d') AS flight_date,
    STR_TO_DATE(scheduled_departure_dt, '%Y-%m-%d %H:%i:%s') AS scheduled_departure_dt,
	STR_TO_DATE(scheduled_arrival_dt, '%Y-%m-%d %H:%i:%s') AS scheduled_arrival_dt,
    STR_TO_DATE(NULLIF(actual_departure_dt, ''), '%Y-%m-%d %H:%i:%s') AS actual_departure_dt,
    STR_TO_DATE(NULLIF(actual_arrival_dt, ''), '%Y-%m-%d %H:%i:%s') AS actual_arrival_dt,
    TRIM(flight_number) AS flight_num,
    CAST(scheduled_elapsed_time AS SIGNED) AS scheduled_elapsed_time,
    CAST(departure_delay AS SIGNED) AS departure_delay,
    CAST(arrival_delay AS SIGNED) AS arrival_delay,
    cancelled_code,
    `year`,
    CAST(`month` AS UNSIGNED) AS month,
	CAST(`day` AS UNSIGNED) AS day,
    weekday

FROM all_flights;

-- creating different views for use

CREATE VIEW airline_performance AS
SELECT
    carrier_code,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_dep_delay,
    AVG(arrival_delay) AS avg_arr_delay,
    SUM(cancelled_code IS NOT NULL) AS cancelled_flights,
    SUM(cancelled_code IS NOT NULL) / COUNT(*) AS cancellation_rate
FROM all_flights_cleaned
GROUP BY carrier_code;

CREATE VIEW route_performance AS
SELECT
    orig_airport,
    dest_airport,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_dep_delay,
    AVG(arrival_delay) AS avg_arr_delay,
    SUM(cancelled_code IS NOT NULL) AS cancelled_flights
FROM all_flights_cleaned
GROUP BY orig_airport, dest_airport;

CREATE VIEW on_time_classification AS
SELECT *,
    CASE
        WHEN arrival_delay <= 0 THEN 'on_time'
        WHEN arrival_delay BETWEEN 1 AND 15 THEN 'slightly_delayed'
        ELSE 'significantly_delayed'
    END AS arrival_status
FROM all_flights_cleaned;








    
    