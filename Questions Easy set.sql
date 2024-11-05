--Q1. Who is the senior most employee based on the job title?

select * from employee
order by levels desc
limit 1

--ANS. Madan Mohan, employee_id 9

--Q2. Which countries have the most invoices?

select count(*) as c, billing_country
from invoice
group by billing_country
order by c asc

--ANS. USA, 131

--Q3. What are top 3 values of the total invoices?

select total from invoice
order by total desc
limit 3

--ANS. 23.759999999999998, 19.8, 19.8

--Q4. Which city has the best customers? We would like to throw a promotional
--Music Festival in the city we made the most money. 
--Write a query that returns one city that has the highest sum of invoice totals.
--Return both city name and sum of the all invoice totals

select sum(total) as invoice_total, billing_city 
from invoice
group by billing_city
order by invoice_total desc
limit 1

--ANS. 273.24000000000007	"Prague"

--Q5. Who is the best customer the customer 
--    who has spent the most money will be awarded as the best customer


select customer.customer_id,customer.first_name, customer.last_name, sum(invoice.total) 
as Total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc;

-- ANS. 5	"R" "Madhav" 144.54000000000002















