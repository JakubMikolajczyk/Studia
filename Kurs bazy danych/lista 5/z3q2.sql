set transaction isolation level repeatable read;
begin TRAN
update liczby set liczba=4
go
sp_lock
WAITFOR DELAY '00:00:03'
update liczby set liczba=4
go
sp_lock
commit

-- GO
-- set transaction isolation level serializable;
-- begin TRAN
-- insert liczby values(151)
-- go
-- sp_lock
-- WAITFOR DELAY '00:00:03'
-- insert liczby values(151)
-- go
-- sp_lock
-- commit