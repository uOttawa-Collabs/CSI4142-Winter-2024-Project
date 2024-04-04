-- Work done by Ali Awil

-- Part 1: Standard OLAP operations
-- a. Drill down and roll up
--     Drill down by season:
SELECT season, SUM(purchase_amount_usd) AS total_purchase_amount
FROM fact
JOIN season ON fact.season_id = season.season_id
GROUP BY season;

--     Roll up by age group:
SELECT age_group_id, SUM(purchase_amount_usd) AS total_purchase_amount
FROM fact
GROUP BY age_group_id;

-- b. Slice
--     Slice by shipping type (e.g., Free Shipping):
SELECT shipping_type, SUM(purchase_amount_usd) AS total_purchase_amount
FROM fact
JOIN shipping_type ON fact.shipping_type_id = shipping_type.shipping_type_id
WHERE shipping_type = 'Free Shipping'
GROUP BY shipping_type;

-- c. Dice
--     Dice by gender and category (e.g., Male customers purchasing Clothing):
SELECT gender, category, SUM(purchase_amount_usd) AS total_purchase_amount
FROM fact
JOIN customer ON fact.customer_id = customer.customer_id
JOIN product ON fact.product_id = product.product_id
WHERE gender = 'Male' AND category = 'Clothing'
GROUP BY gender, category;

--     Dice by season and age group (e.g., Winter purchases by customers aged 30-40):
SELECT season, age_group_id, SUM(purchase_amount_usd) AS total_purchase_amount
FROM fact
JOIN season ON fact.season_id = season.season_id
WHERE season = 'Winter' AND age_group_id BETWEEN 4 AND 6
GROUP BY season, age_group_id;

-- d. Combining OLAP operations
--     Combining drill down and slice (e.g., Drill down by season and slice by shipping type):
SELECT season, shipping_type, SUM(purchase_amount_usd) AS total_purchase_amount
FROM fact
JOIN season ON fact.season_id = season.season_id
JOIN shipping_type ON fact.shipping_type_id = shipping_type.shipping_type_id
GROUP BY season, shipping_type;

--     Combining roll up and dice (e.g., Roll up by age group and dice by gender):
SELECT age_group_id, gender, SUM(purchase_amount_usd) AS total_purchase_amount
FROM fact
JOIN customer ON fact.customer_id = customer.customer_id
GROUP BY age_group_id, gender;

--     Combining drill down, roll up, and slice (e.g., Drill down by season, roll up by age group, and slice by shipping type):
SELECT season, age_group_id, shipping_type, SUM(purchase_amount_usd) AS total_purchase_amount
FROM fact
JOIN season ON fact.season_id = season.season_id
JOIN shipping_type ON fact.shipping_type_id = shipping_type.shipping_type_id
GROUP BY season, age_group_id, shipping_type;

--     Combining all OLAP operations (e.g., Drill down by season, roll up by age group, slice by shipping type, and dice by gender):
SELECT season, age_group_id, shipping_type, gender, SUM(purchase_amount_usd) AS total_purchase_amount
FROM fact
JOIN season ON fact.season_id = season.season_id
JOIN shipping_type ON fact.shipping_type_id = shipping_type.shipping_type_id
JOIN customer ON fact.customer_id = customer.customer_id
GROUP BY season, age_group_id, shipping_type, gender;

-- Part 2: Explorative operation
-- a. Iceberg queries
--     Find the top three seasons with the highest total purchase amounts:
SELECT season, SUM(purchase_amount_usd) AS total_purchase_amount
FROM fact
JOIN season ON fact.season_id = season.season_id
GROUP BY season
ORDER BY total_purchase_amount DESC
LIMIT 3;

-- b. Windowing queries
--     Display the ranking of age groups in terms of total purchase amounts:
SELECT age_group_id, SUM(purchase_amount_usd) AS total_purchase_amount,
       RANK() OVER (ORDER BY SUM(purchase_amount_usd) DESC) AS age_group_rank
FROM fact
GROUP BY age_group_id
ORDER BY total_purchase_amount DESC;

-- c. Using the Window clause
--     Compare the total purchase amounts in different seasons for each age group:
SELECT season, age_group_id, SUM(purchase_amount_usd) AS total_purchase_amount,
       LAG(SUM(purchase_amount_usd)) OVER (PARTITION BY age_group_id ORDER BY season) AS previous_season_purchase_amount,
       LEAD(SUM(purchase_amount_usd)) OVER (PARTITION BY age_group_id ORDER BY season) AS next_season_purchase_amount
FROM fact
JOIN season ON fact.season_id = season.season_id
GROUP BY season, age_group_id
ORDER BY season, age_group_id;
