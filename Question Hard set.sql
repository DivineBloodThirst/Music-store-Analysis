--Q1 Find how much amount spent by each customer on artists?
-- Write a query to return customer name, artist name and total spent?

with best_selling_artist as (

select artist.artist_id as artist_id, artist.name as artist_name, 
sum(invoice_line.unit_price*invoice_line.quantity) as "Total Cost"
from invoice_line
join track on track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
group by 1
order by 3 desc
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
sum(il.unit_price*il.quantity)
as "Amount Spent" from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc;

--ANS. Run the query

--Q2. We want to find out the most popular music genre for each counry.
-- We determine the most popular genre as the genre with the highest of
-- purchases.Write a query that return each country along with the top genre.
-- for countries where the maximum number of purchases is shared return all genres.

with popular_genre as
(
  select count(invoice_line.quantity) as purchases, customer.country, genre.name, 
  genre.genre_id, row_number() over(partition by customer.country order by count(invoice_line.quantity) desc)
  as "Row No."
  from invoice_line
  join invoice on invoice.invoice_id = invoice_line.invoice_id
  join customer on customer.customer_id = invoice.customer_id
  join track on track.track_id = invoice_line.track_id
  join genre on genre.genre_id = track.genre_id
  group by 2,3,4
  order by 2 asc, 1 desc
)
select * from popular_genre where "Row No." <= 1

-- Method 2

with recursive
     sales_per_country as(
                 select count(*) as purchases_per_genre, customer.country, genre.name,
				 genre.genre_id
				 from invoice_line
				 join invoice on invoice.invoice_id = invoice_line.invoice_id
				 join customer on customer.customer_id = invoice.customer_id
				 join track on track.track_id = invoice_line.track_id
				 join genre on genre.genre_id = track.genre_id
				 group by 2,3,4
				 order by 2
	 ),

	 max_genre_per_country as (select max(purchases_per_genre) as max_genre_number, country
	 from sales_per_country
	 group by 2
	 order by 2)


select sales_per_country.*	
from sales_per_country
join max_genre_per_country on sales_per_country.country = max_genre_per_country.country
where sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number

--Q3. Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent.
-- For countries where the top amount spent is shared, provide all customers who spent this amount.

with recursive
    customer_with_country as (
             select customer.customer_id, first_name, last_name, billing_country, sum(total)
			 as "Total Spending" from invoice
			 join customer on customer.customer_id = invoice.customer_id
			 group by 1,2,3,4
			 order by 2,3 desc),

country_max_spending as (
        select billing_country, max("Total Spending") as max_spending
		from customer_with_country
		group by billing_country )


select cc.billing_country, cc."Total Spending", cc.first_name, cc.last_name, cc.customer_id
from customer_with_country cc
join country_max_spending ms
on cc.billing_country = ms.billing_country
where cc."Total Spending" = ms.max_spending
order by 1

--Method 2

with customer_with_country as (
    select customer.customer_id, first_name, last_name, billing_country, sum(total) as total_spending,
	row_number() over(partition by billing_country order by sum(total) desc) as "Row No."
	from invoice
	join customer on customer.customer_id = invoice.customer_id
	group by 1,2,3,4
	order by 4 asc, 5 desc)
select * from customer_with_country where "Row No." <= 1


















