CREATE MATERIALIZED VIEW trip_stat AS
    SELECT
        tz_pickup.zone AS pickup_zone,
        tz_dropoff.zone AS dropoff_zone,
        AVG(EXTRACT(EPOCH FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime))) AS average_trip_time,
        MIN(EXTRACT(EPOCH FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime))) AS min_trip_time,
        MAX(EXTRACT(EPOCH FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime))) AS max_trip_time
    FROM
        trip_data td
    JOIN
        taxi_zone tz_pickup ON td.pulocationid = tz_pickup.location_id
    JOIN
        taxi_zone tz_dropoff ON td.dolocationid = tz_dropoff.location_id
    GROUP BY
        tz_pickup.zone, tz_dropoff.zone;


SELECT * FROM trip_stat ORDER BY average_trip_time DESC LIMIT 3;


CREATE MATERIALIZED VIEW trip_count
    SELECT
        tz_pickup.zone AS pickup_zone,
        tz_dropoff.zone AS dropoff_zone,
        COUNT(*) AS pair_count
    FROM
        trip_data td
    JOIN
        taxi_zone tz_pickup ON td.pulocationid = tz_pickup.location_id
    JOIN
        taxi_zone tz_dropoff ON td.dolocationid = tz_dropoff.location_id
    GROUP BY
        tz_pickup.zone, tz_dropoff.zone;


SELECT * FROM trip_count WHERE pickup_zone = 'Yorkville East' AND dropoff_zone = 'Steinway' ;
