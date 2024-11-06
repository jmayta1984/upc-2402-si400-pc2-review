/*
Ejercicio 17
*/
select ProductName, UnitPrice
from Products
where Discontinued = 1 and UnitPrice > (select avg(UnitPrice) from Products)
go

/*
Ejercicio 20
*/
select *
from Products
where  Discontinued = 0 and CategoryID = 8 and ProductID not in (select  P.productid
								from Products as p
									inner join [Order Details] as OD on P.ProductID = OD.ProductID
									inner join Orders as O on OD.OrderID = O.OrderID
								where Discontinued = 0 and CategoryID = 8 and OrderDate between '20160801' and '20160815')

/*
Ejercicio 22
*/
create function FItemsQuantyByCategoryByProductByYear (@year int) returns table
as
return
(select CategoryName, C.CategoryID, ProductName, P.ProductID, sum(Quantity) as Total
from Categories as C 
	inner join Products as P on C.CategoryID = P.CategoryID
	inner join [Order Details] as OD on P.ProductID = OD.ProductID
	inner join Orders as O on OD.OrderID = O.OrderID
where YEAR(OrderDate) = @year
group by CategoryName, C.CategoryID, ProductName, P.ProductID)
go

create function FProductWithMaxByCategoryByYear(@year int ) returns table
return
	select t1.CategoryID, t1.CategoryName, t1.ProductID, t1.ProductName, t1.total
	from dbo.FItemsQuantyByCategoryByProductByYear(@year) as t1
			inner join (select CategoryName, CategoryID, MAX(Total) as Total
						from dbo.FItemsQuantyByCategoryByProductByYear(@year)
						group by CategoryName, CategoryID) as t2
							on t1.CategoryID = t2.CategoryID and t1.Total = t2.Total
