-- analytics view 

USE ads507;

DROP VIEW IF EXISTS airline_delay_summary;
DROP VIEW IF EXISTS route_delay_summary;
DROP VIEW IF EXISTS daily_delay_trend;

CREATE VIEW airline_delay_summary AS
SELECT
    airline,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay)   AS avg_arrival_delay,
    SUM(cancelled_flag) / COUNT(*) AS cancellation_rate
FROM flights_clean
GROUP BY airline;

CREATE VIEW route_delay_summary AS
SELECT
    origin,
    dest,
    COUNT(*) AS total_flights,
    AVG(arrival_delay) AS avg_arrival_delay
FROM flights_clean
GROUP BY origin, dest;

CREATE VIEW daily_delay_trend AS
SELECT
    flight_date,
    COUNT(*) AS total_flights,
    AVG(arrival_delay) AS avg_arrival_delay
FROM flights_clean
GROUP BY flight_date;
