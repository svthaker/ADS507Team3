-- imported CSV into ads507.flights_sample_3m via Workbench Import Wizard

USE ads507;

TRUNCATE TABLE flights_raw;

INSERT INTO flights_raw (FL_DATE, AIRLINE, ORIGIN, DEST, DEP_DELAY, ARR_DELAY, CANCELLED)
SELECT
  STR_TO_DATE(FL_DATE, '%Y-%m-%d') AS FL_DATE,
  TRIM(AIRLINE) AS AIRLINE,
  TRIM(ORIGIN)  AS ORIGIN,
  TRIM(DEST)    AS DEST,
  NULLIF(DEP_DELAY, '') + 0 AS DEP_DELAY,
  NULLIF(ARR_DELAY, '') + 0 AS ARR_DELAY,
  NULLIF(CANCELLED, '') + 0 AS CANCELLED
FROM flights_sample_3m;

SELECT COUNT(*) AS raw_rows FROM flights_raw;
