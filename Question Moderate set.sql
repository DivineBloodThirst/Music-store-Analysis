--Q1. Write a query to return the email, first name, last name, & Genre of all the 
-- rock Music listeners. Return your list ordered alphabetically by email starting with A

select distinct email, first_name, last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
     select track_id from track
	 join genre on track.genre_id = genre.genre_id
	 where genre.name like 'Rock'
)
order by email;

--Q2. Lets invite the artist who have written the most rock music in our dataset.
--  Write a query that returns the Artist name and total track count of the top 10 rock bands.

select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10

--ANS. "22"	"Led Zeppelin"	114


--Q3. Return all the rock names that have the song length longer than the average song length.
--  Return the name and milliseconds for each track. 
-- Order by the song length with the longest songs listed first

select name, milliseconds
from track
where milliseconds > (
     select avg(milliseconds) as avg_track_length
	 from track)
order by milliseconds desc

--ANS. Run the query




























