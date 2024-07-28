# Creating Indexes in Databases

Indexes are essential for optimizing database performance by speeding up data retrieval. This guide explains how to create indexes in various database systems.

## What is an Index?

An index is a database structure that improves the speed of data retrieval operations on a table. It functions similarly to a book index, allowing for quick look-up of information.

## Why Use Indexes?

- **Faster Query Performance:** Reduces data retrieval time.
- **Efficient Sorting and Searching:** Enhances operations involving sorting and searching.
- **Enforces Uniqueness:** Ensures column values are unique when needed.

## Creating Indexes

### MySQL / PostgreSQL / SQL Server

#### Creating a Simple Index

~~~~sql
CREATE INDEX idx_employeeid ON Employees(EmployeeID);
~~~~

#### Creating a Unique Index

~~~~sql
CREATE UNIQUE INDEX idx_unique_employeeid ON Employees(EmployeeID);
~~~~

#### Creating a Composite Index

~~~~sql
CREATE INDEX idx_name_department ON Employees(LastName, Department);
~~~~

## Dropping Indexes

### MySQL 

~~~~sql
DROP INDEX idx_employeeid ON Employees;
~~~~

### PostgreSQL

~~~~sql
DROP INDEX idx_employeeid;
~~~~

### SQL Server

~~~~sql
DROP INDEX Employees.idx_employeeid;
~~~~

## Viewing Existing Indexes

### MySQL 

~~~~sql
SHOW INDEX FROM Employees;
~~~~

### PostgreSQL 

~~~~sql
SELECT * FROM pg_indexes WHERE tablename = 'Employees';
~~~~

### SQL Server 

~~~~sql
EXEC sp_helpindex 'Employees';
~~~~