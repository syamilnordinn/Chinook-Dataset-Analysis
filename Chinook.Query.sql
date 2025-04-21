--Total Sales by each customer
SELECT c.firstname, c.lastname, c.customerId, SUM(quantity*Unitprice) as sale
FROM PortfolioProject.dbo.InvoiceLine as il
Join PortfolioProject.dbo.Invoice as i
ON il.InvoiceId = i.InvoiceId
JOIN PortfolioProject.dbo.customer as c
ON c.customerId = i.customerId
GROUP BY c.CustomerId, c.firstname, c.lastname
ORDER BY sale DESC;

-- Artist with highest total sales
SELECT TOP 1 a.name, a.artistid, SUM(il.quantity*il.unitprice) as total_sales
FROM PortfolioProject.dbo.artist as a 
JOIN PortfolioProject.dbo.album as al
ON a.artistid = al.artistid
JOIN PortfolioProject.dbo.track as t
ON t.albumid = al.albumid
JOIN PortfolioProject.dbo.invoiceline as il
ON il.trackid = t.trackid
GROUP BY a.name, a.artistid
ORDER BY total_sales DESC 

--Total Tracks in each album
SELECT al.title, al.albumid, COUNT(trackid) as totaltracks
FROM PortfolioProject.dbo.album as al
JOIN PortfolioProject.dbo.track as t
ON t.albumid = al.albumid
GROUP BY al.title, al.albumid
ORDER BY totaltracks DESC

--Customers who have not made any purchase
select customerid
FROM PortfolioProject.dbo.invoice
WHERE invoiceid IS NULL

--Most popular genre by sale
SELECT TOP 1 g.name, SUM(il.unitprice * quantity) as total_sales
FROM PortfolioProject.dbo.genre as g
JOIN PortfolioProject.dbo.track as t
ON g.genreid = t.genreid
JOIN PortfolioProject.dbo.invoiceline as il
ON il.trackid = t.trackid
GROUP BY g.name
ORDER BY total_sales DESC

-- Invoices made by a specific customer (by their ID).
SELECT firstname, lastname, i.*
FROM PortfolioProject.dbo.customer as c
JOIN PortfolioProject.dbo.invoice as i
ON c.customerid = i.customerid

--All the employees with their manager's name (self-join)
SELECT e.employeeid, e.firstname, ep.employeeid as managerid, ep.firstname
FROM PortfolioProject.dbo.employee as e
LEFT JOIN PortfolioProject.dbo.employee as ep
ON e.reportsto = ep.employeeid

-- the tracks that have been sold the most
SELECT il.trackid, t.name, SUM(quantity) tracks_sold
FROM PortfolioProject.dbo.track as t
JOIN PortfolioProject.dbo.invoiceline as il
ON il.trackid = t.trackid
GROUP BY il.trackid, t.name
ORDER BY tracks_sold DESC

--Artist number of customers from each country
WITH x as
(SELECT  a.artistid, c.customerid, c.country, ROW_NUMBER()over(PARTITION BY a.artistid, c.customerid order by a.artistid) rowno
FROM PortfolioProject.dbo.customer as c
JOIN PortfolioProject.dbo.invoice as i
on c.customerid = i.customerid
JOIN PortfolioProject.dbo.invoiceline as il
ON il.invoiceid = i.invoiceid
join PortfolioProject.dbo.track as t
on t.trackid = il.trackid
join  PortfolioProject.dbo.album as al
on al.albumid = t.albumid
join PortfolioProject.dbo.artist as a
on a.artistid = al.artistid)

SELECT artistid, country, count(*)
FROM x 
WHERE rowno = 1
GROUP BY artistid, country
ORDER BY artistid


--OR 


SELECT a.ArtistId, a.name, c.Country, COUNT(DISTINCT c.CustomerId) AS NumCustomers
FROM PortfolioProject.dbo.Customer c
JOIN PortfolioProject.dbo.Invoice i 
ON c.CustomerId = i.CustomerId
JOIN PortfolioProject.dbo.InvoiceLine il 
ON i.InvoiceId = il.InvoiceId
JOIN PortfolioProject.dbo.Track t 
ON il.TrackId = t.TrackId
JOIN PortfolioProject.dbo.Album al 
ON t.AlbumId = al.AlbumId
JOIN PortfolioProject.dbo.Artist a 
ON al.ArtistId = a.ArtistId
GROUP BY a.ArtistId, a.name, c.Country
ORDER BY a.ArtistId;

--Artists with most customers from the USA and United Kingdom
SELECT *
FROM
(
SELECT a.ArtistId, a.name, c.Country, COUNT(DISTINCT c.CustomerId) AS NumCustomers
FROM PortfolioProject.dbo.Customer c
JOIN PortfolioProject.dbo.Invoice i 
ON c.CustomerId = i.CustomerId
JOIN PortfolioProject.dbo.InvoiceLine il 
ON i.InvoiceId = il.InvoiceId
JOIN PortfolioProject.dbo.Track t 
ON il.TrackId = t.TrackId
JOIN PortfolioProject.dbo.Album al 
ON t.AlbumId = al.AlbumId
JOIN PortfolioProject.dbo.Artist a 
ON al.ArtistId = a.ArtistId
GROUP BY a.ArtistId, a.name, c.Country) AS customerss
WHERE country in('USA', 'United Kingdom')
ORDER BY country, NumCustomers DESC

--Most Popular Genre per Country
WITH x as
(SELECT country, g.name, count(*) as ttlpurchase
FROM PortfolioProject.dbo.Track as t
JOIN PortfolioProject.dbo.genre as g
ON t.genreid = g.genreid
JOIN PortfolioProject.dbo.invoiceline as il
ON il.trackid = t.trackid
JOIN PortfolioProject.dbo.invoice as i
ON i.invoiceid = il.invoiceid
JOIN PortfolioProject.dbo.customer as c
ON c.customerid = i.customerid
GROUP BY country, g.name)

SELECT *
FROM 
(SELECT country, name, DENSE_RANK()OVER(PARTITION BY country ORDER BY ttlpurchase DESC) as rank
FROM x) as ranking
WHERE rank = 1 

--Tracks that were never purchased
SELECT trackid, name
FROM  PortfolioProject.dbo.Track 
WHERE trackid NOT IN
(SELECT trackid
from PortfolioProject.dbo.invoiceline)

-- Number of purchase per customer
SELECT customerid, COUNT(InvoiceId) num
FROM PortfolioProject.dbo.invoice
GROUP BY customerid

--Most popular album
SELECT al.title, al.albumid, COUNT(il.invoiceid) ttlpurchase
FROM PortfolioProject.dbo.album as al
JOIN PortfolioProject.dbo.track as t
ON al.albumid = t.albumid
JOIN PortfolioProject.dbo.invoiceline as il
ON il.trackid = t.trackid
GROUP BY al.albumid, al.title
ORDER BY ttlpurchase DESC

--Monthly Revenue
SELECT DATEPART(Month, invoicedate) as month, SUM(total) ttlsales
FROM PortfolioProject.dbo.invoice
GROUP BY DATEPART(Month, invoicedate)
ORDER BY ttlsales DESC

--Top Employees by Sales
SELECT supportrepid, e.firstname, e.lastname, SUM(total) as totalsales
FROM PortfolioProject.dbo.invoice as i
JOIN  PortfolioProject.dbo.customer as c
ON i.customerid = c.customerid
JOIN PortfolioProject.dbo.employee as e
ON e.employeeid = c.supportrepid 
GROUP BY SupportRepId, e.firstname, e.lastname

--Employees with no Sales
SELECT employeeid
FROM PortfolioProject.dbo.employee
except
SELECT supportrepid
FROM PortfolioProject.dbo.customer






