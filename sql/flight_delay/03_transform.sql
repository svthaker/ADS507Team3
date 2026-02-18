USE ads507;

TRUNCATE TABLE flights_clean;

INSERT INTO flights_clean (
    flight_date, airline, origin, dest,
    departure_delay, arrival_delay, cancelled_flag
)
SELECT
    FL_DATE,
    TRIM(AIRLINE),
    TRIM(ORIGIN),
    TRIM(DEST),
    COALESCE(DEP_DELAY, 0),
    COALESCE(ARR_DELAY, 0),
    COALESCE(CANCELLED, 0)
FROM flights_raw;

SELECT COUNT(*) AS clean_rows FROM flights_clean;
