/*
Ejercicio 06:
Muestre el código y nombre de todos los clientes (nombre de compañía) que tienen órdenes 
pendientes de despachar.
*/

select distinct O.CustomerID, CompanyName
from Orders as O
	inner join Customers as C on O.CustomerID = C.CustomerID
where ShippedDate is null
go

/*
Ejercicio 07:
Muestre el código y nombre de todos los clientes (nombre de compañía) que tienen órdenes 
pendientes de despachar, y la cantidad de órdenes con esa característica.
*/

select O.CustomerID, CompanyName, count(*) as Quantity
from Orders as O
	inner join Customers as C on O.CustomerID = C.CustomerID
where ShippedDate is null
group by O.CustomerID, CompanyName
go

/*
Ejercicio 08:
Encontrar los pedidos que debieron despacharse a una ciudad o código postal diferente de la ciudad 
o código postal del cliente que los solicitó. Para estos pedidos, mostrar el país, ciudad y código postal 
del destinatario, así como la cantidad total de pedidos por cada destino
Customers: country, city, postalCode (CustomerID)
Orders:shippcountry, shippcity, shipppostalCode, OrderID (CustomerID)
*/

select Shipcountry, Shipcity, ShippostalCode, count(OrderID) as Quantity
from Customers as C
	inner join Orders as O on C.CustomerID = O.CustomerID
where (city <> ShipCity) or (PostalCode <> ShipPostalCode)
group by shipcountry, shipcity, shippostalCode
go

/*
Ejercicio 09:
Seleccionar todas las compañías de envío (código y nombre) que hayan efectuado algún despacho a 
México entre el primero de enero y el 28 de febrero de 2018.
Formatos sugeridos a emplear para fechas:
• Formatos numéricos de fecha (por ejemplo, '4/15/2018')
• Formatos de cadenas sin separar (por ejemplo, '20181207')

Shippers: ShipperID, CompanyName (ShipperID)
Orders: ShipDate, ShipCountry (ShipVia)
*/

select distinct ShipperID, CompanyName
from Shippers as S
	inner join Orders as O on S.ShipperID = O.ShipVia
where (O.ShipCountry = 'Mexico') and (ShippedDate between '20180101' and '20180228')
go

/*
Ejercicio 10
Mostrar los nombres y apellidos de los empleados junto con los nombres y apellidos de sus respectivos 
jefes
*/

select E.LastName, E.FirstName, E.ReportsTo, B.EmployeeID, B.LastName, B.FirstName
from Employees as E
	left join Employees as B on E.ReportsTo = B.EmployeeID
go

/*
Ejercicio 11
Mostrar el ranking de venta anual por país de origen del empleado, tomando como base la fecha de 
las órdenes, y mostrando el resultado por año y venta total (descendente).
Employees: country (EmployeeID)
Orders:	OrderDate (EmployeeID) (OrderID)
Order Details: UnitPrice, Quantity, Discount (OrderID)
*/

select Country, year(OrderDate) as Year, SUM((UnitPrice*Quantity)*(1-Discount)) as Total
from Employees as E 
	inner join Orders as O on E.EmployeeID = O.EmployeeID
	inner join [Order Details] as OD on O.OrderID = OD.OrderID
group by Country,year(OrderDate) 
order by  Total desc

/*
Ejercicio 12
Mostrar de la tabla Orders, para los pedidos cuya diferencia entre la fecha de despacho y la fecha de 
la orden sea mayor a 4 semanas, las siguientes columnas:
OrderId, CustomerId, Orderdate, Shippeddate, diferencia en días, diferencia en semanas y diferencia 
en meses entre ambas fechas.
*/

/*
Ejercicio 13
La empresa tiene como política otorgar a los jefes una comisión del 0.5% sobre la venta de sus 
subordinados. Calcule la comisión mensual que le ha correspondido a cada jefe por cada año 
(basándose en la fecha de la orden) según las ventas que figuran en la base de datos. Muestre el 
código del jefe, su apellido, el año y mes de cálculo, el monto acumulado de venta de sus 
subordinados, y la comisión obtenida
*/
