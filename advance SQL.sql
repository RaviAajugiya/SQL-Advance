select upper('Ravi')
select lower('Ravi')
select len('Ravi')
select CONCAT('sds','dsd')
select SUBSTRING('Ravi', 2 , 3)
select DATEPART(MONTH, '2023/09/29')

SELECT SUBSTRING('Hello World', 7, 5) AS ExtractedString;

SELECT right('SQL Server', 5) AS LeftString;
SELECT LTRIM('   Trim Me') AS TrimmedString;

select REPLACE('Ravi Aajugiya', 'Ravi', 'Rahul')

select GETDATE()
select CURRENT_TIMESTAMP
select GETUTCDATE()
select DATEPART(month, '2003/03/29')
select DATENAME(year, '2003/03/29')
select DATENAME(month, '2003/03/29')
select DATEDIFF(day,'2003/03/29','2023/09/25')


select DATEADD(MONTH,5,'2003/03/29')
select EOMONTH('2003/02/20')
select FORMAT(GETDATE(), 'dddd-mmmm-yyyy')
select FORMAT(GETDATE(), 'hh:mm:ss') 

select convert(varchar, 123)
SELECT CAST('3' AS INT)
SELECT CAST('2023-09-25' AS DATE); -- Casts the string '2023-09-25' to a DATE data type
SELECT CAST(GETDATE() AS VARCHAR(20))


SELECT PARSE('12/16/2010' AS datetime2)

select abs(-5656565)
select ROUND(123.5564546,6)
select CEILING(25.78)
select floor(25.46)


create function add_five(@num as int)
returns int
as
begin
return(@num+5)
end

select dbo.add_five(46)

create function get_data(@gender as varchar(20))
returns table
as return(select * from actor where act_gender = @gender)


select * from dbo.get_data('M')


select employee_id, salary, ROW_NUMBER() over (order by salary) from employees

SELECT employee_id,salary, ROW_NUMBER() over (order by salary) FROM employees
order by salary
OFFSET 2 ROWS   
FETCH next 5 ROWS ONLY;  

select * from employees

--temp table

select employee_id, first_name, last_name 
into #tempEmployee
from employees
where department_id = 100

select * from #tempEmployee


create table ##tempEmp
(
	name varchar(65),
)

alter table ##tempEmp
add emp_id varchar(10)

alter table ##tempEmp
add unique(name)

select * from ##tempEmp

exec TempDB..SP_HELP ##tempEmp

DECLARE @table_var table (id int,name varchar(20))
INSERT INTO @table_var (id, name) VALUES (1, 'John'), (2, 'Jane'), (3, 'Mark');

SELECT * FROM @table_var;

select * from employees;


--cursor
declare @emp_id int;
declare @emp_name varchar(20);

DECLARE s11 CURSOR FOR SELECT employee_id, first_name FROM employees
OPEN s11

FETCH NEXT FROM s11 into @emp_id, @emp_name
while(@@FETCH_STATUS = 0)
begin
 FETCH NEXT FROM s11 into @emp_id, @emp_name
 print 'id = ' + cast(@emp_id as varchar(40)) + ' name = ' + @emp_name
end

CLOSE s11
DEALLOCATE s11

declare s2 cursor FOR SELECT employee_id, first_name FROM employees
OPEN s2
FETCH NEXT FROM s2

begin try 
declare @result INT = 10/0
end try
begin catch
print 'An error ocurred ' + Error_message();
end catch


--date function

select GETDATE()
select DATEPART(year,'2023-09-29')
select DATEPART(WEEKDAY,'2023-09-29')
select DATEDIFF(month,'2023-09-29','2023-09-29')
select dateadd(month, 8 ,'2023-09-29')
SELECT DATENAME(WEEKDAY, '2023-07-28');

select CONVERT(varchar, getdate(),101)
select cast('2023-07-28' as DATE)

select FORMAT('2023-07-28', 'mmmm-dddd-yy')
SELECT FORMAT(GETDATE(), 'MMMM dd, yyyy');
SELECT FORMAT('2023-07-28', 'yyyy-MM-dd') AS FormattedDate

SELECT FORMAT(cast('2023-07-28' as datetime), 'dddd');



select employee_id,first_name,salary,department_id, sum(salary) over 
(partition by department_id) as temp from employees

select sum(salary), department_id from employees 
group by department_id


select *, ROW_NUMBER() over (order by department_id) as di from employees

select *, 
ROW_NUMBER() over (partition by department_id order by department_id) as di 
from employees

select employee_id, first_name, salary, department_id ,
rank() over (partition by department_id order by salary desc) as rank
from employees

select employee_id, first_name, salary, department_id ,
dense_rank() over (partition by department_id order by salary desc) as rank
from employees

select employee_id, first_name, salary, department_id ,
lag(salary,1,0) over (partition by department_id order by salary desc) as prev_sal,
lead(salary,1,0) over (partition by department_id order by salary desc) as prev_sal
from employees

order by department_id, salary



select * from employees where first_name  = 'Kimberely' COLLATE Latin1_General_Bin


SELECT first_name, CASE WHEN first_name = 'John' COLLATE Latin1_General_Bin THEN 'Match' 
		WHEN UPPER(first_name) = 'JOHN' COLLATE Latin1_General_Bin THEN 'Case-insensitive Match'
		ELSE 'No Match' END AS MatchStatus FROM employees;


CREATE TYPE LessonType AS TABLE
(LessonId   INT, 
 LessonName VARCHAR(100)
)

CREATE TABLE Lesson ( 
        Id    INT PRIMARY KEY, 
        LName VARCHAR(50)
                )

select * from Lesson

CREATE PROCEDURE Usp_InsertLesson 
@ParLessonType LessonType READONLY
AS
INSERT INTO Lesson
SELECT * FROM @ParLessonType

DECLARE @VarLessonType AS LessonType
 
INSERT INTO @VarLessonType
VALUES ( 1, 'Math'
       )
INSERT INTO @VarLessonType
VALUES ( 2, 'Science'
       )
INSERT INTO @VarLessonType
VALUES ( 3, 'Geometry'
       )

EXECUTE Usp_InsertLesson @VarLessonType

