--- 1
set transaction isolation level repeatable read;
begin transaction

WAITFOR DELAY '00:00:03'
select * from liczby
WAITFOR DELAY '00:00:03'

commit

--- 2
-- GO
-- set transaction isolation level serializable;

-- insert liczby values ( 10 );

-- begin transaction

-- WAITFOR DELAY '00:00:03'
-- select * from liczby
-- WAITFOR DELAY '00:00:03'


-- commit