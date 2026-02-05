USE flight_delay_and_cancellation;
SHOW TABLES;

SELECT COUNT(*) FROM flights;
SELECT COUNT(*) FROM flights_sample_3m;
SELECT COUNT(*) FROM flights_part_aa;

RENAME TABLE flights_sample_3m TO flights_raw;

SELECT COUNT(*) FROM flights_raw;

SELECT
  SUM(CASE WHEN airline IS NULL OR airline='' THEN 1 ELSE 0 END) AS missing_airline,
  SUM(CASE WHEN origin IS NULL OR origin='' THEN 1 ELSE 0 END) AS missing_origin,
  SUM(CASE WHEN dest IS NULL OR dest='' THEN 1 ELSE 0 END) AS missing_dest
FROM flights_raw;

DESCRIBE flights_raw;

CREATE TABLE flights_clean AS
SELECT
  -- surrogate key
  ROW_NUMBER() OVER () AS flight_id,

  TRIM(AIRLINE) AS airline,
  TRIM(ORIGIN) AS origin,
  TRIM(DEST)   AS dest,

  STR_TO_DATE(FL_DATE, '%Y-%m-%d') AS flight_date,

  CAST(DEP_DELAY AS SIGNED) AS dep_delay,
  CAST(ARR_DELAY AS SIGNED) AS arr_delay,

  CASE
    WHEN CANCELLED = 1 THEN 1
    ELSE 0
  END AS cancelled_flag,

  CASE WHEN DEP_DELAY >= 15 THEN 1 ELSE 0 END AS dep_delayed_15_flag,
  CASE WHEN ARR_DELAY >= 15 THEN 1 ELSE 0 END AS arr_delayed_15_flag,


  DISTANCE,
  AIR_TIME

FROM flights_raw;

SELECT COUNT(*) FROM flights_raw; 
-- 398200
SELECT COUNT(*) FROM flights_clean;
-- 398200

SELECT * FROM flights_clean LIMIT 10;

-- check missing fields 
SELECT
  SUM(CASE WHEN airline IS NULL OR airline='' THEN 1 ELSE 0 END) AS missing_airline,
  SUM(CASE WHEN origin  IS NULL OR origin='' THEN 1 ELSE 0 END) AS missing_origin,
  SUM(CASE WHEN dest    IS NULL OR dest='' THEN 1 ELSE 0 END) AS missing_dest
FROM flights_clean;
-- all 0 

-- adding indexes 
ALTER TABLE flights_clean
ADD INDEX idx_flight_date (flight_date),
ADD INDEX idx_airline (airline(10)),
ADD INDEX idx_route (origin(5), dest(5)),
ADD INDEX idx_cancelled (cancelled_flag);

SHOW INDEX FROM flights_clean;

-- airline summary (delays and cancellations)
CREATE OR REPLACE VIEW airline_delay_summary AS
SELECT
  airline,
  COUNT(*) AS total_flights,
  SUM(cancelled_flag) AS cancelled_flights,
  ROUND(AVG(dep_delay), 2) AS avg_dep_delay,
  ROUND(AVG(arr_delay), 2) AS avg_arr_delay,
  ROUND(100 * AVG(dep_delayed_15_flag), 2) AS pct_dep_delayed_15,
  ROUND(100 * AVG(arr_delayed_15_flag), 2) AS pct_arr_delayed_15
FROM flights_clean
GROUP BY airline
ORDER BY pct_dep_delayed_15 DESC;

-- route summary (origin to destination) 
CREATE OR REPLACE VIEW route_delay_summary AS
SELECT
  origin,
  dest,
  COUNT(*) AS total_flights,
  SUM(cancelled_flag) AS cancelled_flights,
  ROUND(AVG(dep_delay), 2) AS avg_dep_delay,
  ROUND(100 * AVG(dep_delayed_15_flag), 2) AS pct_dep_delayed_15
FROM flights_clean
GROUP BY origin, dest
HAVING COUNT(*) >= 100
ORDER BY pct_dep_delayed_15 DESC;

-- daily trend 
CREATE OR REPLACE VIEW daily_delay_trend AS
SELECT
  flight_date,
  COUNT(*) AS total_flights,
  SUM(cancelled_flag) AS cancelled_flights,
  ROUND(AVG(dep_delay), 2) AS avg_dep_delay,
  ROUND(100 * AVG(dep_delayed_15_flag), 2) AS pct_dep_delayed_15
FROM flights_clean
GROUP BY flight_date
ORDER BY flight_date;

-- test
SELECT * FROM airline_delay_summary LIMIT 10;
SELECT * FROM route_delay_summary LIMIT 10;
SELECT * FROM daily_delay_trend LIMIT 10;










