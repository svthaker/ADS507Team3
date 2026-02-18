USE ads507;

INSERT INTO pipeline_run_log (dataset_code, step_name, row_count, status, notes)
SELECT 'flight_delay', 'raw_loaded', COUNT(*), 'SUCCESS', 'Loaded staging -> flights_raw'
FROM flights_raw;

INSERT INTO pipeline_run_log (dataset_code, step_name, row_count, status, notes)
SELECT 'flight_delay', 'clean_built', COUNT(*), 'SUCCESS', 'Transformed flights_raw -> flights_clean'
FROM flights_clean;

SELECT *
FROM pipeline_run_log
WHERE dataset_code = 'flight_delay'
ORDER BY run_id DESC
LIMIT 10;
