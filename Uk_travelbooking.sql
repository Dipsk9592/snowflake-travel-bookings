-- Create a schema to organize our travel booking tables.
CREATE SCHEMA IF NOT EXISTS TRAVEL_DB.BOOKINGS;

-- Check how many booking records are stored in the table.
SELECT COUNT(*) AS total_bookings
FROM TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS;

-- Display every column and its data type in our travel bookings table.
DESCRIBE TABLE TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS;


-- Q1: Display the first 10 booking records.
SELECT *
FROM TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS
LIMIT 10;


-- Q2: Count the total number of bookings in the table.
SELECT COUNT(*) AS total_bookings
FROM TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS;


-- Q3: Display all bookings where the destination country is Spain.
SELECT
    booking_id,
    customer_name,
    destination_city,
    travel_start_date
FROM TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS
WHERE destination_country = 'Spain';


-- Q4: Find all cancelled bookings and display their details.
SELECT
    booking_id,
    customer_name,
    destination_city,
    status
FROM TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS
WHERE status = 'Cancelled';


-- Q5: Find bookings where no discount value has been recorded.
SELECT
    booking_id,
    customer_name,
    discount_pct
FROM TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS
WHERE discount_pct IS NULL;


-- Q6: Calculate revenue for each booking after applying any discount.
SELECT
    booking_id,
    travellers * price_per_person_gbp
        * (1 - COALESCE(discount_pct, 0) / 100) AS revenue_gbp
FROM TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS;


-- Q7: Calculate total revenue by package type, excluding cancelled bookings.
SELECT
    package_type,
    ROUND(
        SUM(travellers * price_per_person_gbp
            * (1 - COALESCE(discount_pct, 0) / 100)),
        2
    ) AS revenue_gbp
FROM TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS
WHERE status <> 'Cancelled'
GROUP BY package_type
ORDER BY revenue_gbp DESC;



-- Q8: Find the destination country with the most bookings.
SELECT
    destination_country,
    COUNT(*) AS bookings
FROM TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS
GROUP BY destination_country
ORDER BY bookings DESC
LIMIT 1;


-- Q9: Calculate the number and percentage of bookings by payment mode.
SELECT
    payment_mode,
    COUNT(*) AS bookings,
    ROUND(
        100 * COUNT(*) / SUM(COUNT(*)) OVER (),
        1
    ) AS pct_share
FROM TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS
GROUP BY payment_mode
ORDER BY bookings DESC;


-- Q10: Find customers who have made more than two bookings.
SELECT
    customer_name,
    COUNT(*) AS bookings
FROM TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS
GROUP BY customer_name
HAVING COUNT(*) > 2;



-- Q11: Calculate average ratings for countries with at least 2 rated trips.
SELECT
    destination_country,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(rating) AS rated_trips
FROM TRAVEL_DB.BOOKINGS.TRAVEL_BOOKINGS
GROUP BY destination_country
HAVING COUNT(rating) >= 2
ORDER BY avg_rating DESC;








