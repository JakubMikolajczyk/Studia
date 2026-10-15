drop table if exists liczby1;
drop table if exists liczby2;
create table liczby1 ( liczba int )
create table liczby2 ( liczba int )
go
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE