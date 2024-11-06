/*
Ejercicio: Crear un procedimiento almacenado que inserte un nuevo cliente. Maneje los errores utilizando transacciones.
*/

create procedure SPInsertCustomer
	@CustomerID nchar(5),
	@CompanyName nvarchar(40),
	@Birthdate date
as
begin
	/*
	declare @Quantity int
	set @Quantity = (select COUNT(*) from Customers where CustomerID = @CustomerID)
	
	if @Quantity = 0
	begin
	insert into Customers(CustomerID, CompanyName, Birthdate)
		values(@CustomerID, @CompanyName, @Birthdate)
	end
	*/
	begin try
		begin transaction TInsertCustomer
		insert into Customers(CustomerID, CompanyName, Birthdate)
			values(@CustomerID, @CompanyName, @Birthdate)
		print 'Cliente ingresado satisfactoriamente'

		commit transaction TInsertCustomer
	end try

	begin catch
		if (@@TRANCOUNT > 0)
		begin
			print error_message()
			rollback transaction TInsertCustomer
		end
	end catch
end 
go

exec SPInsertCustomer @CustomerId = 'WIWOL', @CompanyName ='Wonka Asociados',@Birthdate ='20180101'
go

/*
Crear un trigger para las operacines de insert, update, delete para la tabla Customers
*/

create trigger TRICustomers on Customers for insert, update, delete
as
begin
	declare @QInserted int
	declare @QDeleted int
	set @QInserted = (select count(*) from inserted)
	set @QDeleted = (select count(*) from deleted)

	if (@QInserted >0 )
	begin
		if (@QDeleted >0)
		begin
			print 'Se actualizo el cliente'
		end
		else
		begin
			print 'Se ha registrado un cliente'
		end
	end
	else 
		if (@QDeleted >0)
		begin
			print 'Se ha borrado el cliente'
		end
end
go

delete from Customers where CustomerID = 'WIWOL'
go
