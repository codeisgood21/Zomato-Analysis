
SELECT
    cc.Country AS country,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(r."Aggregate rating") FILTER (WHERE r."Aggregate rating" > 0), 2) AS avg_rating,
    ROUND(AVG(r."Average Cost for two"), 2) AS avg_cost_for_two
FROM restaurants r
JOIN country_codes cc ON r."Country Code" = cc."Country Code"
GROUP BY cc.Country
ORDER BY restaurant_count DESC;


SELECT
    City AS city,
    COUNT(*) AS restaurant_count,
    ROUND(AVG("Aggregate rating") FILTER (WHERE "Aggregate rating" > 0), 2) AS avg_rating,
    ROUND(AVG("Average Cost for two"), 2) AS avg_cost_for_two
FROM restaurants
GROUP BY City
ORDER BY restaurant_count DESC
LIMIT 20;


WITH exploded AS (
    SELECT TRIM(cuisine) AS cuisine
    FROM restaurants, UNNEST(string_split(Cuisines, ',')) AS t(cuisine)
    WHERE Cuisines IS NOT NULL
)
SELECT
    cuisine,
    COUNT(*) AS restaurant_count
FROM exploded
GROUP BY cuisine
ORDER BY restaurant_count DESC
LIMIT 20;


WITH exploded AS (
    SELECT TRIM(cuisine) AS cuisine, "Aggregate rating" AS rating
    FROM restaurants, UNNEST(string_split(Cuisines, ',')) AS t(cuisine)
    WHERE Cuisines IS NOT NULL AND "Aggregate rating" > 0
)
SELECT
    cuisine,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(rating), 2) AS avg_rating
FROM exploded
GROUP BY cuisine
HAVING COUNT(*) >= 20
ORDER BY avg_rating DESC
LIMIT 20;


SELECT
    ROUND(CORR("Average Cost for two", "Aggregate rating"), 3) AS cost_vs_rating,
    ROUND(CORR("Price range", "Aggregate rating"), 3) AS price_range_vs_rating
FROM restaurants
WHERE "Aggregate rating" > 0;

SELECT
    "Price range" AS price_range,
    COUNT(*) AS restaurant_count,
    ROUND(AVG("Aggregate rating") FILTER (WHERE "Aggregate rating" > 0), 2) AS avg_rating,
    ROUND(AVG("Average Cost for two"), 2) AS avg_cost_for_two
FROM restaurants
GROUP BY "Price range"
ORDER BY price_range;


SELECT
    "Rating text" AS rating_text,
    COUNT(*) AS restaurant_count,
    ROUND(AVG("Aggregate rating"), 2) AS avg_rating
FROM restaurants
WHERE "Aggregate rating" > 0
GROUP BY "Rating text"
ORDER BY avg_rating DESC;

SELECT
    "Restaurant Name" AS restaurant_name,
    City AS city,
    Cuisines AS cuisines,
    "Average Cost for two" AS cost_for_two,
    "Aggregate rating" AS rating,
    ROUND("Aggregate rating" / NULLIF("Average Cost for two", 0) * 1000, 3) AS value_score
FROM restaurants
WHERE "Aggregate rating" >= 4.0 AND "Average Cost for two" > 0
ORDER BY value_score DESC
LIMIT 20;

SELECT
    "Has Online delivery" AS has_online_delivery,
    COUNT(*) AS restaurant_count,
    ROUND(AVG("Aggregate rating") FILTER (WHERE "Aggregate rating" > 0), 2) AS avg_rating,
    ROUND(AVG(Votes), 1) AS avg_votes
FROM restaurants
GROUP BY "Has Online delivery";

SELECT
    "Has Table booking" AS has_table_booking,
    COUNT(*) AS restaurant_count,
    ROUND(AVG("Aggregate rating") FILTER (WHERE "Aggregate rating" > 0), 2) AS avg_rating,
    ROUND(AVG("Average Cost for two"), 2) AS avg_cost_for_two
FROM restaurants
GROUP BY "Has Table booking";

FROM restaurants
ORDER BY city;

SELECT
    "Restaurant Name" AS restaurant_name,
    City AS city,
    Cuisines AS cuisines,
    "Average Cost for two" AS cost_for_two,
    "Price range" AS price_range,
    "Aggregate rating" AS rating,
    Votes AS votes
FROM restaurants
WHERE ($city IS NULL OR City = $city)
  AND ($min_rating IS NULL OR "Aggregate rating" >= $min_rating)
ORDER BY rating DESC, votes DESC
LIMIT 200;
