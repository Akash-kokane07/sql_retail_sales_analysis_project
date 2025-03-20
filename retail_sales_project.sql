-- SQL Retail Sales Analysis - P1
CREATE DATABASE retail_sales_project;

-- Create Table
CREATE TABLE retail_sales
            (
				transactions_id int8 PRIMARY KEY,
				sale_date date,
				sale_time time,
				customer_id	int,
				gender VARCHAR(15),
				age int,
				category varchar(15),
				quantiy	int,
				price_per_unit float4,
				cogs float4,
				total_sale float4
			)
			
SELECT * FROM retail_sales

-- DATA CLEANING
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE customer_id IS NULL

SELECT * FROM retail_sales
WHERE gender IS NULL

SELECT * FROM retail_sales
WHERE age IS NULL

--
SELECT * FROM retail_sales
WHERE
	 transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 age IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL;

-- 
DELETE FROM retail_sales
WHERE
	 transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 age IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL;

-- DATA EXPLORATION
-- COUNT OF SALES DATA WE HAVE ?
SELECT COUNT(*) AS total_sales_data 
FROM retail_sales;

-- HOW MANY NUMBERS OF UNIQUE CUSTOMER DO WE HAVE ?
SELECT COUNT(DISTINCT(customer_id)) as total_customers 
FROM retail_sales;

-- HOW MANY CATEGORIES DO WE HAVE ?
SELECT DISTINCT(category) AS number_of_categories
FROM retail_sales;

-- DATA ANALYSIS OVER BUSINESS KEY PROBLEM
-- Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
-- the quantity sold is more than 3 in the month of Nov-2022:
SELECT * 
FROM retail_sales 
WHERE category = 'Clothing'
      AND 
	  quantiy > 3
      AND 
	  sale_date BETWEEN '2022-11-01' AND '2022-11-30';
	  
-- Q3.Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category, SUM(total_sale) 
FROM retail_sales
GROUP BY category;

-- Q4.Write a SQL query to find the average age of customers who purchased items from 
-- the 'Beauty' category.:
SELECT ROUND(AVG(age)) AS avg_age 
FROM retail_sales
WHERE category = 'Beauty';

-- Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT gender, 
       category, 
	   COUNT(*) as total_transaction
FROM retail_sales
GROUP BY gender, 
         category;

-- Q7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT year,
       month,
	   avg_sale
FROM
(
	SELECT 
		  EXTRACT(YEAR FROM sale_date) AS Year,
		  EXTRACT(MONTH FROM sale_date) AS Month,
		  AVG(total_sale) AS avg_sale,
		  RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 1, 2
) as t1
WHERE rank = 1;

--Q8.Write a SQL query to find the top 5 customers based on the highest total sales:
SELECT customer_id, 
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9.Write a SQL query to find the number of unique customers who purchased items from each category:
SELECT category, 
	   COUNT(DISTINCT customer_id) AS count_of_unique_customers
FROM retail_sales
GROUP BY category;

-- Q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
     CASE
	   WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	   ELSE 'Evening'
	 END AS shift
FROM retail_sales
)
SELECT 
	 shift,
	 COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

-- END OF THE PROJECT --