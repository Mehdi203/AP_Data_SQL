--1
select VendorContactLName+','+VendorContactFName as 'Full Name'
from vendors
order by VendorContactLName, VendorContactFName
---------------------------
-- 2. (2 points) Raul
-- Write a SELECT statement that returns three columns:
-- InvoiceTotal, 10% of Invoice Total, Invoice Total plus 10%.
-- (For example, if InvoiceTotal is 100.0000, 10% is 10.0000, and Plus 10% is 110.0000.) 
-- Sort the result set by InvoiceTotal, with the largest invoice first
Select InvoiceTotal, (InvoiceTotal * .1) as 'InvoiceTotal10P', (InvoiceTotal * 1.1) as 'InvoiceTotalPlus10P'
from Invoices
order by InvoiceTotal desc
---------------------------
-- 3 -- Jazlyn
SELECT VendorID, VendorName, 
	CASE
    WHEN VendorState = 'CA' Then 'California'
    ELSE 'Out Of State'
END AS Location
FROM Vendors
----------------------------------

--Question 4
Select InvoiceNumber, TermsDescription
From Invoices AS I
Inner Join Terms AS T
ON I.TermsID = T.TermsID

---------------------------

--5. (1 point) George
--Display vendor names who had an Invoice in 2016

--1st Method
USE AP
SELECT Distinct  VendorName
FROM Invoices,Vendors 
WHERE Invoices.VendorID = Vendors.VendorID
AND InvoiceDate BETWEEN '12/31/2015' AND '12/31/2016 23:59:59'

--2nd method
select distinct vendorname as 'vendorname'
from invoices I
join vendors V
on V.vendorid=I.vendorid
where year(I.invoicedate)=2016
Order by  VendorName

-----------------------------------------------------

--6. (1 point) George
--Redo Question 5 displaying the top 15 vendors
--1st Method
USE AP
SELECT  Distinct Top 15 VendorName
FROM Invoices,Vendors 
WHERE Invoices.VendorID = Vendors.VendorID
AND InvoiceDate BETWEEN '12/31/2015' AND '12/31/2016 23:59:59'

--2nd method
select  Distinct  Top 15 vendorname as 'vendorname'
from invoices I
join vendors V
on V.vendorid=I.vendorid
where year(I.invoicedate)=2016
Order by  VendorName

----------------------------

--7
select * from vendors
inner join invoices
on vendors.vendorid=invoices.vendorid
---------------------------

-- 8. (1 points) Raul
-- Write a SQL query to return results as shown in example below. 
-- Do not return vendors without a phone number.
-- Example result:
-- Phone Information
-- The Job track phone number is (800)555-8725
Select 'The ' + trim(VendorName) + ' phone number is ' + VendorPhone AS 'PhoneInformation' 
from Vendors
where VendorPhone is not null
--------------------------------

-- 9. -- Jazlyn
USE AP

SELECT VendorName
FROM Vendors
WHERE VendorName LIKE '%ata%' OR VendorName LIKE '%oto%'
ORDER BY VendorName ASC;
-----------------------------------

--Question 10

--Method 1
 Select InvoiceDueDate, DATEADD(day, 10, InvoiceDueDate ) AS InvoiceDueDatePlus10d
 From Invoices
 Order by InvoiceDueDate

 --Method 2
 Select InvoiceDueDate, (InvoiceDueDate + 10) AS InvoiceDueDatePlus10d
 From Invoices
 Order by InvoiceDueDate
---------------------------------

--11. (2 points) George
--Write a query that will return the total of all the payments

USE AP
SELECT sum(PaymentTotal) as 'PaymentTotal' 
From Invoices
---------------------------

--12
select count(*) as 'the number of invoices for each termID', termsid as 'termsid'
from invoices
group by termsid
---------------------------


-- 13. (2 points) Raul
-- Write a SELECT statement that returns two columns from the Invoices table: VendorID and 
-- PaymentSum, where PaymentSum is the sum of the PaymentTotal column. 
-- Group the result set by VendorID.
Select VendorID, sum(PaymentTotal) as 'PaymentSum'
from Invoices
Group by VendorID
--------------------------------

-- 14. -- Jazlyn
Select Top 10 VendorName, Sum(PaymentTotal) AS PaymentSum From
Invoices AS I Join Vendors AS V
ON I.VendorID = V.VendorID
Group by VendorName
Order by PaymentSum Desc

----------------------------------

 --Question 15

Select VendorName, Count(InvoiceNumber) AS InvoiceCount, Sum(InvoiceTotal) AS InvoiceSum 
From Invoices AS I Inner Join Vendors AS V
ON I.VendorID = V.VendorID
Group by VendorName
Order by InvoiceCount Desc
---------------------------------

--16. (3 points)
--Write a query that returns the invoice number, invoice date, and invoice total.
--Return only those results that are greater than the average invoice total.
--Sort your results by the invoice total
--Method 1
DECLARE @AvgtotalInvoice int
SELECT @AvgtotalInvoice = avg(InvoiceTotal)
FROM Invoices
SELECT InvoiceNumber, InvoiceDate, sum(InvoiceTotal) as "Sum of Each Total Invoice"
FROM Invoices
GROUP BY InvoiceNumber,InvoiceDate
HAVING sum(InvoiceTotal)> @AvgtotalInvoice
Order BY InvoiceNumber

--Method 2: Rewrite using subquery 
Select InvoiceNumber, InvoiceDate,sum(InvoiceTotal) as "Sum of Each Total Invoice"
from Invoices
GROUP BY InvoiceNumber,InvoiceDate
having
	sum(InvoiceTotal) > (
		select avg(InvoiceTotal) from Invoices
		)
---------------------------------

--17. (3 points)
--Write a SELECT statement that answers this question:
--Which invoices have a PaymentTotal that’s greater than the average PaymentTotal for all paid invoices?
--Return the InvoiceNumber and InvoiceTotal for each invoice.

DECLARE @AvgpaymentTotal money
SELECT @AvgpaymentTotal = avg(PaymentTotal)
FROM Invoices
WHERE PaymentDate IS not null
SELECT InvoiceNumber, sum(InvoiceTotal) as 'Sum of Each Total Invoice',PaymentTotal, @AvgpaymentTotal as 'Avg Payment Total'
FROM Invoices
GROUP BY InvoiceNumber, PaymentTotal
HAVING PaymentTotal> @AvgpaymentTotal
Order BY InvoiceNumber
---------------------------------

--18. (3 points) George
--For each invoice that has PaymentDate (not null), calculate and display how many days
--Before the due date the invoice was paid. More specifically, display invoiceID, invoice number,
--Invoice date, invoice due date, payment date, and calculated column that is the number of days
--FROM payment date to due date (this column should have positive values WHERE invoice was paid
--Before due date, and negative if it was paid after due date).

Select InvoiceID, InvoiceNumber, Format(InvoiceDate, 'yyy-mm-dd') AS InvoiceDate, Format(InvoiceDueDate, 'yyy-mm-dd') AS  InvoiceDueDate, Format(PaymentDate, 'yyy-mm-dd') AS PaymentDate, DATEDIFF(day,PaymentDate, InvoiceDueDate) AS PaymenttoInvoiceDiff 
From Invoices
Where PaymentDate IS NOT Null
Order by PaymenttoInvoiceDiff Desc
---------------------------------

--19
select invoiceid , count(invoiceid) as 'the amount of invoiceid'
from invoicelineitems
group by invoiceid
having count(invoiceid)>1

-- 20. (2 points) Raul
-- Add InvoiceNumber and VendorName to the previous query (you will need to JOIN two more tables).

Select i.InvoiceNumber, v.VendorName, il.InvoiceID, count(il.InvoiceID) as 'Lines for Invoice'
from InvoiceLineItems il
join invoices i
on il.InvoiceID = i.InvoiceID
join Vendors v
on i.VendorID = v.VendorID
group by i.InvoiceNumber, v.VendorName, il.InvoiceID
having count(il.InvoiceID)>1
--------------------------------

-- 21. -- Jazlyn

SELECT gla.AccountNo, AccountDescription
FROM GLAccounts gla
LEFT JOIN InvoiceLineItems ivi
	ON gla.AccountNo = ivi.AccountNo
WHERE InvoiceID IS NULL
-------------------------------

 --Question 22

--Format(InvoiceDate, 'yyy-mm-dd')
Select V.VendorID, V.VendorName, Format(Max(InvoiceDate), 'yyy-mm-dd') AS InvoiceDateRecent From Vendors AS V
Join Invoices AS I ON V.VendorID = I.VendorID
Group by V.VendorID,V.VendorName
--------------------------------
--23
--Method 1
CREATE FUNCTION fdinvoiceID1 (@invoiceid int)
RETURNS varchar(30)
BEGIN
RETURN (SELECT case
	when invoicetotal-(credittotal+paymenttotal)=0 then 'paid off'
	else 'not paid off'
	end as invoicediscription
from invoices WHERE invoiceid= @invoiceid);
END;

select dbo.fdinvoiceID1(5) 


--Method 2
CREATE FUNCTION fdinvoiceID (@invoiceid int)
RETURNS varchar(30)
BEGIN
RETURN (SELECT IIF(invoicetotal-(credittotal+paymenttotal)=0, 'not paid off','paid off')    ----this part is more simple.
from invoices  WHERE invoiceid= @invoiceid);
END;

select dbo.fdinvoiceID(25) 

------------------------------------------------------------------
--24. (4 points)
--Create a store procedure for inserting invoices. The procedure should receive three parameters (InvoiceNumber, InvoiceTotal and InvoiceDueDate) and insert them into the invoice tables. You can enter Null for Payment date and 0 for payment total and credit total. You need to check if the vendorID exists before inserting the query. If not, throws a meaningful error.
--Please write the syntax for executing store proc below the syntax for store procedure.

IF (object_id('spInvoiceReport') IS Not NUll)
Drop Proc spInsertInvoices

Create proc spInsertInvoices
@InvNo int,
@InvTotal money,
@InvDueDate smalldatetime,
@VendorID int
As
If (@VendorID not in (select VendorID from Vendors))
Print 'Vendor ID is invalid';
Else
Begin
Insert into Invoices (VendorID, InvoiceNumber, InvoiceDate, InvoiceTotal, PaymentTotal, CreditTotal, TermsID, InvoiceDueDate, PaymentDate)
values(@VendorID, @InvNo, getdate(), @InvTotal, 0, 0, (Select DefaultTermsID from Vendors where VendorID=@VendorID), @InvDueDate, NULL)
Insert into InvoiceLineItems (InvoiceID, InvoiceSequence, AccountNo, InvoiceLineItemAmount, InvoiceLineItemDescription)
values ((Select Max(InvoiceID) from Invoices), 1, (Select DefaultAccountNo from Vendors where VendorID=@VendorID), @InvTotal, 'Item description')
End



exec spInsertInvoices @InvNo=990, @InvTotal=990, @InvDueDate='2021-09-23', @VendorID=0
exec spInsertInvoices @InvNo=990, @InvTotal=990, @InvDueDate='2021-09-23', @VendorID=110

--------------------------------
--25. (3 Points) George
--Write a script to create a new schema. Then, create a new table within that schema. (Choose any names you like.)

CREATE SCHEMA Assignment3_25;
GO
CREATE TABLE Assignment3_25.demo(
    demo_id INT PRIMARY KEY IDENTITY,
    description VARCHAR(200),
    created_at DATETIME2 NOT NULL
);
SELECT * FROM sys.schemas;


 --Question 26
-------------------------
Begin tran
Delete Invoices Where VendorID in(
Select VendorID from Vendors Where VendorState in ('NV', 'TN')
)
Delete Vendors Where VendorState in ('NV', 'TN')
--Rollback tran 
Commit tran
