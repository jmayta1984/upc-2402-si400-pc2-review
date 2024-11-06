/*
Ejercicio 01:
Crear una función que retorne la cantidad de pedidos realizados.
*/

create function FOrdersQuantity() returns int
as
begin
	return (select count(*) from Orders)
end
go

select dbo.FOrdersQuantity() as Quantity
go
/*
Ejercicio 02:
Crear una función que retorne la cantidad de pedidos realizados para un determinado año
ingresado como parámetro.
*/

create function FOrdersQuantityByYear(@Year int) returns int
as
begin
	return (select count(*) from Orders where Year(OrderDate)=@Year)
end
go

select dbo.FOrdersQuantityByYear(2016) as Quantity
go
/*
Ejercicio 03:
Crear una función que retorne la cantidad de artículos vendidos en un determinado año.
*/

create function FArticlesQuantityByYear(@Year int) returns int
as
begin
	return (select sum(Quantity) as Total
	from [Order Details] as OD
		inner join Orders as O on OD.OrderID = O.OrderID
	where Year(OrderDate) =  @Year
	group by Year(OrderDate))
end
go

select dbo.FArticlesQuantityByYear(2016) as Quantity
go

/*
Ejercicio 04:
Crear una función donde ingrese el nombre del país destinatario del pedido y
retorne el total de las unidades vendidas.
*/
create function FArticlesQuantityByCountry(@Country nvarchar(15)) returns int
as
begin
	declare @Total int
	set @Total = (select sum(Quantity) as Total
	from [Order Details] as OD
		inner join Orders as O on OD.OrderID = O.OrderID
	where ShipCountry = @Country
	group by ShipCountry)

	if (@Total is null)
	begin
		return 0
	end
	return @Total
end
go

select dbo.FArticlesQuantityByCountry('Peru') as Quantity
go

/*
Ejercicio 05:
Crear una función que retorne los clientes que realizaron pedidos en un determinado año
ingresado como parámetro. Para cada cliente debe mostrar el código y nombre.
*/

create function FCustomersWithOrderByYear(@Year int) returns table
as 
return	select distinct C.CustomerID, CompanyName
		from Customers as C
			inner join Orders as O on C.CustomerID = O.CustomerID
		where Year(OrderDate) = @Year
go

select * from dbo.FCustomersWithOrderByYear(2018)
go

/*
Ejercicio 06:
Crear un procedimiento almacenado que permitar registrar los datos de un cliente.
*/
create procedure SPInsertCustomer
	@CustomerID nchar(5),
	@CompanyName nvarchar(40),
	@Birthdate date
as
begin
	declare @Quantity int
	set @Quantity = (select COUNT(*) from Customers where CustomerID = @CustomerID)
	
	if @Quantity = 0
	begin
	insert into Customers(CustomerID, CompanyName, Birthdate)
		values(@CustomerID, @CompanyName, @Birthdate)
	end
	
end
go

execute SPInsertCustomer @CustomerID = 'WIWOL', @CompanyName = 'Willy Wonka', @Birthdate = '20150101'
go

select * from Customers where CustomerID = 'WIWOL'
go
