# Database Specification:
## DBMS Used: PostgreSQL 15
## Database Name: used-car-db
## Data Dummy Generation Language: Python (using Faker library)
To access the Python module and functions employed for generating dummy data, kindly consult the [Generate Dummy Data Repository](https://github.com/akhmadtaufik/create-dummy-for-db).

# Database Purpose:
The purpose of this database is to support an online platform for the sale of used cars. It enables users to create detailed advertisements for the used cars they want to sell, provides contact information for sellers, allows potential buyers to search for cars based on the seller's location, car brand, and body type, and enhances interaction between sellers and buyers by providing accurate and relevant information about the available used cars.

# Design Requirements:
The database design includes the following tables:
1. `body_types`: Types of vehicle body shapes.
2. `manufactures`: Vehicle brands.
3. `models`: Vehicle models associated with each brand.
4. `cars`: Detailed information about each vehicle.
5. `locations`: Geographic location information.
6. `users`: User data for the vehicle platform.
7. `advertisements`: Information about vehicle advertisements.
8. `bids`: Bids made on vehicle advertisements.

The design ensures data integrity through primary keys, foreign keys, and constraints. Indexes are created to optimize data retrieval, and constraints are enforced to maintain data consistency and validity.

# ER Diagram:
![ER Diagram](https://github.com/akhmadtaufik/project-relational-database/blob/main/assets/ERD-3.png)

# Sample SQL Queries with Questions:
Here are sample SQL queries that address specific questions related to the Online Used Car Sales Database:

**1. How to display a list of cars listed by the user Gambira Saptono?**
```sql
select 
	c.car_id ,
	m.manufacture_name as merk,
	m2.model_name as model,
	c.year_manufactured as year,
	a.price,
	a.date_posted 
from 
	cars c 
inner join manufactures m 
	using(manufacture_id)
inner join models m2 
	using(model_id)
inner join advertisements a 
	using(car_id)
where 
	a.user_id in (
		select 
			u.user_id
		from 
			users u 
		where 
			u.first_name = 'Gambira' and 
			u.last_name = 'Saptono'
	)
;
```
Output:
![Nomor 1](https://github.com/akhmadtaufik/project-relational-database/blob/main/assets/transaction-nomor-3.png)

**2. How to find used cars with the lowest price using the keyword "Camry" to provide relevant information?**
```sql
select 
	distinct c.car_id ,
	m.manufacture_name as merk,
	m2.model_name as model,
	c.year_manufactured as year,
	a.price
from 
	cars c 
inner join manufactures m 
	using(manufacture_id)
inner join models m2 
	using(model_id)
inner join advertisements a 
	using(car_id)
where
	m2.model_name ilike '%camry%'
order by a.price 
;
```
Output:
![Nomor 2](https://github.com/akhmadtaufik/project-relational-database/blob/main/assets/transaction-nomor-4.png)

**3. What is the percentage difference in car prices by model compared to the average bid price offered by customers over the last 6 months? **
```sql
WITH ModelAvgPrices AS (
    SELECT
        mo.model_name,
        AVG(a.price) AS avg_price
    FROM
        models mo
    JOIN
        cars c ON mo.model_id = c.model_id
    JOIN
        advertisements a ON c.car_id = a.car_id
    GROUP BY
        mo.model_name
),
ModelAvgBids AS (
    SELECT
        mo.model_name,
        AVG(b.bid_price) AS avg_bid_6month
    FROM
        models mo
    JOIN
        cars c ON mo.model_id = c.model_id
    JOIN
        advertisements a ON c.car_id = a.car_id
    JOIN
        bids b ON a.ad_id = b.ad_id
    WHERE
        b.datetime_bid >= NOW() - INTERVAL '6 months'
    GROUP BY
        mo.model_name
)
SELECT
    m.model_name,
    COALESCE(ROUND(mp.avg_price, 0), 0) AS avg_price,
    COALESCE(ROUND(mab.avg_bid_6month, 0), 0) AS avg_bid_6month,
    COALESCE(ROUND(mp.avg_price, 0), 0) - COALESCE(ROUND(mab.avg_bid_6month, 0), 0) AS difference,
    CASE
        WHEN COALESCE(ROUND(mp.avg_price, 0), 0) = 0 THEN NULL
        ELSE (COALESCE(ROUND(mp.avg_price, 0), 0) - COALESCE(ROUND(mab.avg_bid_6month, 0), 0)) / COALESCE(ROUND(mp.avg_price, 0), 0) * 100
    END AS difference_percent
FROM
    public.models m
LEFT JOIN
    ModelAvgPrices mp ON m.model_name = mp.model_name
LEFT JOIN
    ModelAvgBids mab ON m.model_name = mab.model_name
;
```
Output:
![Nomor 3](https://github.com/akhmadtaufik/project-relational-database/blob/main/assets/analytical-nomor-4.png)

# USAGE:
Follow these steps to utilize the Online Used Car Database with PostgreSQL 15:

**Step 1:** Clone or Download this repository.

**Step 2:** Install PostgreSQL Server on your Windows/Linux/macOS machine, and take note of your PostgreSQL superuser password.

**Step 3:** Optionally, you can install a PostgreSQL database management tool like pgAdmin for a graphical interface.

**Step 4:** Create a connection to your PostgreSQL Server using your preferred database management tool. You can connect locally or remotely, depending on your PostgreSQL Server setup.

**Step 5:** Run the SQL scripts provided in the database or back-up folder. Ensure that you execute them with appropriate privileges, especially when creating the database schema and tables.

**Step 6:** You are now ready to work with the database. You can start by executing SELECT queries to retrieve data according to your needs.

&copy; 2023 Akhmad Taufik Ismail
