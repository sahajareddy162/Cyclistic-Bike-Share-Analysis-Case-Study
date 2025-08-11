-- 1. Create the database
CREATE DATABASE IF NOT EXISTS cyclistic;
USE cyclistic;

-- 2. Create the table with data types
CREATE TABLE IF NOT EXISTS bike_trips (
    ride_id VARCHAR(255),
    rideable_type VARCHAR(50),
    started_at TIME,
    ended_at TIME,
    start_station_name VARCHAR(255),
    start_station_id VARCHAR(255),
    end_station_name VARCHAR(255),
    end_station_id VARCHAR(255),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50),
    ride_length TIME,
    day_of_week VARCHAR(10)
);

-- 3. (Assumes data is already imported)

-- 4. Total row count
SELECT COUNT(*) AS total_rows FROM bike_trips;

-- 5. Check for NULLs in key columns
SELECT * FROM bike_trips
WHERE ride_id IS NULL
   OR rideable_type IS NULL
   OR started_at IS NULL
   OR ended_at IS NULL
   OR member_casual IS NULL;

-- 6. Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- 7. Delete rows with negative ride_length (data quality check)
DELETE FROM bike_trips
WHERE TIME_TO_SEC(ride_length) < 0;

-- 8. Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;

-- 9. Verify cleaned data
SELECT COUNT(*) AS cleaned_rows FROM bike_trips;

-- 10. Avg ride length (in minutes if formatted correctly) by user type
SELECT 
    member_casual, 
    ROUND(AVG(TIME_TO_SEC(ride_length)/60), 2) AS avg_ride_length_minutes
FROM bike_trips
GROUP BY member_casual;

-- 11. Rides per day of the week by user type
SELECT 
    day_of_week, 
    member_casual, 
    COUNT(*) AS total_rides
FROM bike_trips
GROUP BY day_of_week, member_casual
ORDER BY total_rides DESC;

-- 12. Rideable type usage by user type
SELECT 
    rideable_type, 
    member_casual, 
    COUNT(*) AS total_rides
FROM bike_trips
GROUP BY rideable_type, member_casual;