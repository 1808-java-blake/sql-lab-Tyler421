-- Part I – Working with an existing database

-- 1.0	Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.
SELECT * FROM employee;
-- Task – Select all records from the Employee table where last name is King.
SELECT * FROM employee WHERE lastname = 'King' ;
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM employee WHERE firstname = 'Andrew' AND reportsto = null;
-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SELECT * FROM album ORDER BY title DESC;
-- Task – Select first name from Customer and sort result set in ascending order by city
SELECT firstname FROM customer ORDER BY city ASC;
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
INSERT INTO genre
VALUES(26, 'Instrumental');

INSERT INTO genre
VALUES(27, 'Video Game');
-- Task – Insert two new records into Employee table
INSERT INTO employee
VALUES(9, 'Couzens', 'Tyler', 'IT Staff', 6, '1995-04-21 00:00:00', '2004-03-04 00:00:00', '123 real street', 'Calgary', 'AB', 'Canada', 'T2P3S4', '+1 (404) 387-6946', '+1 (404) 387-6946','ty.couzens@gmail.com');

INSERT INTO employee
VALUES(10, 'Doe', 'John', 'IT Staff', 4, '1997-05-27 00:00:00', '2004-05-12 00:00:00', '321 real street', 'Calgary', 'AB', 'Canada', 'T2P4U5', '+1 (123) 456-7890', '+1 (123) 456-7890','john.doe@gmail.com');
-- Task – Insert two new records into Customer table
INSERT INTO customer
VALUES(60, 'Jay', 'Dog', null, '102 Grand Cresent', 'Alpharetta', 'GA', 'United States', '30009', null, null, 'example@yahoo.com', 3);

INSERT INTO customer
VALUES(61, 'Example', 'Person', null, '103 Grand Cresent', 'Alpharetta', 'GA', 'United States', '30009', null, null, 'example@gmasil.com', 3);
-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE customer
SET firstname = 'Robert', lastname = 'Walter'
WHERE CustomerID = 32;
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
 UPDATE artist
 SET name = 'CCR'
 WHERE artistid = 76;
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SELECT * FROM invoice
	WHERE billingaddress LIKE 'T%'
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SELECT * FROM invoice
	WHERE total BETWEEN 15 AND 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM employee
	WHERE hiredate BETWEEN '2003-06-01 00:00:00' AND '2004-03-01 00:00:00';
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).

-- 3.0	SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
CREATE OR REPLACE FUNCTION get_time(res result) RETURNS result AS $$
BEGIN
	OPEN res FOR SELECT CURRENT_TIME;
	RETURN res;
END;
$$ LANGUAGE plpgsql;
-- Task – create a function that returns the length of a mediatype from the mediatype table
CREATE OR REPLACE FUNCTION mediatype_length(ref refcursor) RETURNS refcursor AS $$
BEGIN
    OPEN ref FOR SELECT LENGTH('Name') FROM "mediatype";
    RETURN ref;
    END;
$$ LANGUAGE plpgsql;
-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION average_total_invoice(ref refcursor) RETURNS refcursor AS $$
BEGIN   
    OPEN ref FOR SELECT CAST(AVG("total")AS DECIMAL(10,2)) FROM "invoice";
    RETURN ref;
    END;
$$ LANGUAGE plpgsql;
-- Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION most_expensive(ref refcursor) RETURNS refcursor AS $$
BEGIN
    OPEN ref FOR SELECT MAX("unitprice") FROM "track";
    RETURN ref;
    END;
$$ LANGUAGE plpgsql;
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION average_price_invoiceline_items(ref refcursor) RETURNS refcursor AS $$
BEGIN 
    OPEN ref FOR SELECT CAST(AVG("unitprice")AS DECIMAL(10,2)) FROM "invoiceline";
    RETURN ref;
    END;
$$ LANGUAGE plpgsql
-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
CREATE OR REPLACE FUNCTION employees_born_after_1968(ref refcursor) RETURNS refcursor AS $$
BEGIN 
    OPEN ref FOR SELECT * FROM employee 
    WHERE birthdate BETWEEN '1969-01-01 00:00:00' AND CURRENT_TIMESTAMP;
    RETURN ref;
    END;
$$ LANGUAGE plpgsql;
-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
CREATE OR REPLACE FUNCTION employee_names(ref refcursor) RETURNS refcursor AS $$
BEGIN 
    OPEN ref FOR SELECT firstname, lastname FROM employee;
    RETURN ref;
    END;
$$ LANGUAGE plpgsql
-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
CREATE OR REPLACE FUNCTION update_ employee_info(employee_id INTEGER, postal_code VARCHAR(10), new_city VARCHAR(25))
RETURNS	VOID AS $$
BEGIN
	UPDATE employee SET employeeid = employee_id, postalcode = postal_code, city = new_city
	WHERE employeeid = employee_id;
END;
$$ LANGUAGE plpgsql;
-- Task – Create a stored procedure that returns the managers of an employee.
CREATE OR REPLACE FUNCTION employee_managers()
RETURNS TABLE (first_name VARCHAR, last_name VARCHAR, reports_to INTEGER, employee_id INTEGER, managers_first_name VARCHAR, managers_last_name VARCHAR)
AS $$
BEGIN
 RETURN QUERY 
 SELECT a.firstname, a.lastname, a.reportsto, b.employeeid, b.firstname, b.lastname 
	FROM employee a, employee b 
	WHERE a.reportsto = b.employeeid;
END;
$$ LANGUAGE plpgsql;

-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
CREATE OR REPLACE FUNCTION customer_with_company()
RETURNS TABLE (first_name VARCHAR, last_name VARCHAR, company_name VARCHAR)
AS $$
BEGIN
 RETURN QUERY 
 SELECT firstname, lastname, company 
		FROM customer;
END;
$$ LANGUAGE plpgsql;
    
-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
CREATE OR REPLACE FUNCTION delete_invoice(id INTEGER)
RETURNS void as $$
BEGIN
	DELETE FROM invoiceline
	WHERE invoiceid IN (SELECT invoiceid FROM invoice);
	DELETE FROM invoice WHERE invoiceid = id;
END;
$$ LANGUAGE plpgsql;
-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
CREATE OR REPLACE FUNCTION add_customer(id INTEGER, new_firstname VARCHAR(15), new_lastname VARCHAR(15), new_email VARCHAR(15))
RETURNS void as $$
BEGIN
	INSERT INTO customer (customerid, firstname, lastname, email)
	VALUES (id, new_firstname, new_lastname, new_email);
END;
$$ LANGUAGE plpgsql;
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
CREATE TABLE employee_log(new_employeeid VARCHAR(20), new_lastname VARCHAR(20), new_firstname VARCHAR(20));
CREATE OR REPLACE FUNCTION add_employee_trig()
RETURNS TRIGGER AS $$
BEGIN
    IF(TG_OP = 'INSERTING') THEN
    INSERT INTO employee_log (new_employeeid, new_lastname, new_firstname)
        VALUES (NEW.employeeid, NEW.lastname, NEW.firstname);
    END IF;
    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;
-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
CREATE TABLE album_log(old_albumid VARCHAR(20), new_albumid VARCHAR(20), old_title VARCHAR(20), new_title VARCHAR(20), old_artistid VARCHAR(20), new_artistid VARCHAR(20));
CREATE OR REPLACE FUNCTION update_album_trig()
RETURNS TRIGGER AS $$
BEGIN
    IF(TG_OP = 'UPDATING') THEN
    INSERT INTO album_log (old_albumid,	new_albumid, old_title, new_title, old_artistid, new_artistid)
        VALUES (OLD.albumid, NEW.albumid, OLD.title, NEW.title, OLD.artistid, NEW.artistid);
    END IF;
    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;
-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
CREATE TABLE customer_log(old_customerid VARCHAR(20), old_firstname VARCHAR(20), old_lastname VARCHAR(20));
CREATE OR REPLACE FUNCTION delete_customer_trig()
RETURNS TRIGGER AS $$
BEGIN
    IF(TG_OP = 'DELETING') THEN
    INSERT INTO customer_log (old_customerid, old_firstname, old_lastname)
        VALUES (OLD.customerid, OLD.firstname, OLD.lastname);
    END IF;
    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;
-- 6.2 INSTEAD OF
-- Task – Create an instead of trigger that restricts the deletion of any invoice that is priced over 50 dollars.
CREATE OR REPLACE FUNCTION delete_invoice_trig()
RETURNS TRIGGER AS $$
BEGIN
    IF(TG_OP = 'DELETING' AND OLD.total <= 50) THEN
    INSERT INTO customer_log (old_invoiceid, old_customerid, old_total)
        VALUES (OLD.invoice OLD.firstname OLD.lastname);
    END IF;
    IF(TG_OP = 'DELETING' AND OLD.total > 50) THEN
    INSERT INTO customer_log (
	    NEW.* = OLD.*;
    END IF;
    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;
-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SELECT firstname, lastname, invoiceid FROM invoice
    INNER JOIN customer ON (invoice.customerid = customer.customerid);
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT customer.customerid, firstname, lastname, invoiceid, total FROM invoice
    FULL OUTER JOIN customer ON (invoice.customerid = customer.customerid);
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SELECT artist.name, album.title FROM artist
    RIGHT JOIN album ON (artist.artistid = album.artistid);
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SELECT * FROM album CROSS JOIN artist 
ORDER BY (name);
-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SELECT * FROM employee e1, employee e2 
    WHERE e1.reportsto = e2.reportsto;
