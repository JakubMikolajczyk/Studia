begin tran
insert liczby2 values ( 1 )
WAITFOR DELAY '00:00:04'
update liczby1 set liczba=10
ROLLBACK