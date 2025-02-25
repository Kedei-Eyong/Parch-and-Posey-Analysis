--Insight on Customers--
---Total number of accounts
SELECT COUNT(DISTINCT id)
FROM accounts a

---Top most profitable customers
SELECT a.name, SUM(o.total_amt_usd) AS total_revenue
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_revenue DESC
LIMIT 10

---Least most profitable customers
SELECT a.name, SUM(o.total_amt_usd) AS total_revenue
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_revenue ASC
LIMIT 10


--Insight on Orders--
---Highest quantity ordered per paper type
SELECT 
	MAX(standard_qty) AS max_standard_quantity, 
	MAX(gloss_qty) AS max_gloss_quantity, 
	MAX(poster_qty) AS max_poster_quantity
FROM orders

---Total number of orders
SELECT SUM(total)
FROM orders

---Most frequent orders
SELECT
    COUNT(DISTINCT standard_qty) AS standard_order_frequency, 
	COUNT(DISTINCT gloss_qty) AS gloss_order_frequency, 
	COUNT(DISTINCT poster_qty) AS poster_order_frequency	
FROM
    orders
	
---Average order value
SELECT AVG(total_amt_usd)
FROM orders

---Average quantity ordered per paper type
SELECT 
	AVG(standard_qty) AS avg_standard_quantity, 
	AVG(gloss_qty) AS avg_gloss_quantity, 
	AVG(poster_qty) AS avg_poster_quantity
FROM orders

---Monthly sales trends from orders
SELECT DATE_TRUNC('month', o.occurred_at) AS month_of_sale, 
	SUM(o.total_amt_usd) AS monthly_income
FROM orders o
GROUP BY month_of_sale
ORDER BY month_of_sale

---Yearly sales trends from orders
SELECT DATE_TRUNC('year', o.occurred_at) AS sales_year, 
	SUM(o.total_amt_usd) AS annual_income
FROM orders o
GROUP BY sales_year
ORDER BY sales_year

---Maximum revenue from orders
SELECT MAX(total_amt_usd)
FROM orders

---Profitability of paper types
SELECT 
	CASE
		WHEN o.standard_qty > 0 THEN 'Standard Paper'
		WHEN o.gloss_qty > 0 THEN 'Gloss Paper'
		WHEN o.poster_qty > 0 THEN 'Poster Paper'
	END AS paper_type,
	SUM(o.standard_amt_usd + o.gloss_amt_usd + o.poster_amt_usd) AS paper_profit,
	SUM(o.standard_qty + o.gloss_qty + o.poster_qty) AS paper_order_quantity
FROM orders o
GROUP BY paper_type
ORDER BY paper_profit DESC
LIMIT 3


--Insights on region--
---Revenue analysis by region
SELECT r.name AS region_name, SUM(o.total_amt_usd) AS region_income
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY r.name
ORDER BY region_income DESC

---Distribution of customers by region
SELECT r.name AS region_name, COUNT(DISTINCT o.account_id) AS region_customers
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY r.name
ORDER BY region_customers


--Insights on sales representatives--
---Revenue from sales representatives
SELECT s.name, SUM(o.total_amt_usd) AS sales_revenue
FROM sales_reps s
JOIN accounts a ON s.id = sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY s.name
ORDER BY sales_revenue DESC 

---Top performing sales representatives
SELECT s.name, SUM(o.total_amt_usd) AS sales_revenue
FROM sales_reps s
JOIN accounts a ON s.id = sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY s.name
ORDER BY sales_revenue DESC                 
LIMIT 5

---Total number of sales representatives
SELECT COUNT(DISTINCT s.id)
FROM sales_reps s


--Insights on web events--
---Order distribution based on web channels
SELECT w.channel AS web_channel, COUNT(o.account_id) AS channel_orders
FROM web_events w
JOIN accounts a ON w.account_id = a.id
JOIN orders o ON a.id = o.account_id
GROUP BY w.channel
ORDER BY channel_orders DESC

---Top web channels with highest orders
SELECT w.channel AS web_channel, COUNT(o.account_id) AS channel_orders
FROM web_events w
JOIN accounts a ON w.account_id = a.id
JOIN orders o ON a.id = o.account_id
GROUP BY w.channel
ORDER BY channel_orders DESC
Limit 3

---Frequency of web events---
SELECT channel, COUNT(*) AS event_count
FROM web_events
GROUP BY channel
ORDER BY event_count DESC