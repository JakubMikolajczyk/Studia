begin tran
insert liczby1 values ( 1 )
WAITFOR DELAY '00:00:04'
update liczby2 set liczba=10
ROLLBACK
