--1. Create a scalar function that accepts string as a parameter and return whether the string is correct mail Id or not
alter function checkMail (@mail as varchar(60))
returns varchar(20)
as
begin
	Return 
	case 
		when @mail like '%@%.%' then 'valid'
		else 'invalid'
	end
end

select dbo.checkMail('abc@mail.com') 

--2. Create a tabular function that accepts one parameter as employee department and return the employees working in that department.
select * from employees

create function dept(@dep_id int)
returns table
as return select * from employees where department_id = @dep_id

select * from dept(60)

--3. Create a function that returns the data of employee records based on the page number passed. Parameters required are PageNumber, PageSize (Hint: use Row_Number, Partition by)
select * from employees
order by employee_id
offset 10 rows
fetch first 10 rows only

create function pagination (@PageNumber int, @PageSize int)
returns table
as return 
	select * from employees
	order by employee_id
	offset @PageSize * (@PageNumber - 1) rows
	fetch first @PageSize rows only

select * from pagination(2,5)

create function pagination (@PageNumber int, @PageSize int)
returns table
as return 
	select *, ROW_NUMBER() over (partiton by employee_id)

--4. Select EmpId, FirstName, LastName, PhoneNumber, Email from Employees’ check the execution plan for the given query and save it. Now, optimize the query and then check the execution plan and save it.
select employee_id, first_name, last_name, phone_number, email from employees
create index emp_index ON employees (employee_id, first_name, last_name, phone_number, email)

--5. Create a stored procedure that prints the employee info in the following format: 'employeename' hired on 'hiredate' has a salary package of 'salarypackage'
--Print only for 10 employees
--Implement it using cursor and then with while loop also

create procedure print_while
as
	declare @count int = (select count(*) from employees)
	declare @first_name varchar(50); 
	declare @hire_date varchar(50); 
	declare @salary int

	select *, ROW_NUMBER() over ( order by employee_id) as rank into #temp2 from employees
	while(@count != 0)
	begin 
		select @first_name = first_name, @hire_date = hire_date, @salary = salary from #temp2 where rank = @count
		print @first_name + ' hired on ' + @hire_date + ' has a salary package of ' + cast(@salary as varchar(20))
		set @count = @count - 1
	end
go
exec print_while


create procedure print_cursor
as
	declare @first_name varchar(50); 
	declare @hire_date varchar(50); 
	declare @salary int
	declare @count int = 10

	declare empprint scroll cursor for select first_name, hire_date, salary from employees

	open empprint
		fetch next from empprint into  @first_name, @hire_date, @salary

	while(@count != 0)
	begin
		print @first_name + ' hired on ' + @hire_date + ' has a salary package of ' + cast(@salary as varchar(20))
		fetch next from empprint into  @first_name, @hire_date, @salary
		set @count = @count - 1
	end

	close empprint
	deallocate empprint
go

drop procedure print_cursor

exec print_cursor
