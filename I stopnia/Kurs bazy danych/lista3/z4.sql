DROP TABLE IF EXISTS SalaryHistory
DROP TABLE IF EXISTS Employees

CREATE TABLE Employees(
    ID INT PRIMARY KEY,
    SalaryGros MONEY)

INSERT INTO Employees VALUES(1, 9000)
INSERT INTO Employees VALUES(2, 100000)
INSERT INTO Employees VALUES(3, 5000)
INSERT INTO Employees VALUES(4, 11000)
INSERT INTO Employees VALUES(5, 5000)


CREATE TABLE SalaryHistory(
    ID INT PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employees(ID),
    Year INT,
    Month INT,
    SalaryNet MONEY,
    SalaryGros MONEY)

INSERT INTO SalaryHistory VALUES(1, 3, 2023, 1, 5000 * 0.83, 5000)
INSERT INTO SalaryHistory VALUES(2, 4, 2023, 1, 11000 * 0.83, 11000)
INSERT INTO SalaryHistory VALUES(3, 4, 2023, 2, 11000 * 0.83, 11000)
INSERT INTO SalaryHistory VALUES(4, 5, 2023, 1, 5000 * 0.83, 5000)
INSERT INTO SalaryHistory VALUES(5, 5, 2023, 2, 5000 * 0.83, 5000)


DROP PROCEDURE IF EXISTS salary
GO


CREATE PROCEDURE salary @n INT AS
BEGIN

    DECLARE @log TABLE(id INT PRIMARY KEY)
    DECLARE @result TABLE(id INT PRIMARY KEY, Salary MONEY)

    DECLARE employeesIDCursor CURSOR FOR SELECT * FROM Employees ORDER BY Employees.[ID]
    DECLARE historyCursor CURSOR FOR SELECT EmployeeID, SalaryHistory.Month, SalaryNet, SalaryGros FROM SalaryHistory WHERE SalaryHistory.[Year] = 2023 ORDER BY SalaryHistory.[EmployeeID], SalaryHistory.[Month]

    
    OPEN employeesIDCursor
    DECLARE @emploID INT
    DECLARE @salaryGros MONEY
    DECLARE @newPerson BIT
    SET @newPerson = 1
    FETCH NEXT FROM employeesIDCursor INTO @emploID, @salaryGros
    WHILE (@@FETCH_STATUS = 0)
        BEGIN
        DECLARE @counter INT
        SET @counter = 1
        DECLARE @emploHisID INT
        DECLARE @sumGros MONEY      
        DECLARE @Net MONEY
        DECLARE @Gros MONEY  
        DECLARE @sumNet MONEY
        DECLARE @prevMonth INT
        DECLARE @actMonth INT
        DECLARE @isFirst BIT    --- 1 if first record is find

        OPEN historyCursor
        FETCH NEXT FROM historyCursor INTO @emploHisID, @actMonth, @sumNet, @sumGros
        SET @prevMonth = @actMonth - 1  --- if not -1 first if is always true
        IF (@emploID = @emploHisID)
            BEGIN
            SET @isFirst = 1
            SET @newPerson = 0
            END
        ELSE
            SET @isFirst = 0

        WHILE (@@FETCH_STATUS = 0 AND @n != 1)
            BEGIN
                
                IF((@emploHisID != @emploID AND @isFirst = 1) OR (@emploHisID = @emploID AND (@prevMonth + 1) != @actMonth)) --- missing salary in one of the previous months
                    BEGIN
                        INSERT INTO @log VALUES(@emploID)
                        BREAK
                    END


                IF((@actMonth + 1) = @n AND @isFirst = 1)
                    BEGIN
                        DECLARE @averageGros MONEY
                        SET @averageGros = (@sumGros + @salaryGros)/(@counter + 1)
                        DECLARE @sumTAX MONEY  --- TAX we paid
                        SET @sumTAX = @sumGros - @sumNet
                        DECLARE @TAXToPay MONEY  ---  TAX(mismatch in calculation) we have to paid monthly to end of year, can be positive if @salaryGros decreased 
                        IF (@averageGros < 10000)   --- 17% TAX
                            BEGIN
                                SET @TAXToPay = (@sumTAX - @sumGros * 0.17)/(13 - @n)
                                INSERT INTO @result VALUES(@emploID, @salaryGros * (1 - 0.17) + @TAXToPay)
                            END
                        ELSE --- 15300 + 32%
                            BEGIN
                                print 'BIG'
                                print @sumGros
                                print @sumTax
                                SET @TAXToPay = (@sumTAX - @sumGros * 0.32 - 15300)/(13 - @n) 
                                print @TAXToPay
                                INSERT INTO @result VALUES(@emploID, @salaryGros * (1 - 0.32) + @TAXToPay)
                            END
                        BREAK
                    END

                SET @prevMonth = @actMonth
                FETCH NEXT FROM historyCursor INTO @emploHisID, @actMonth, @Net, @Gros
                IF(@emploHisID = @emploID AND @isFirst = 0)
                    BEGIN
                        SET @isFirst = 1
                        SET @sumGros = @Gros
                        SET @sumNet = @Net
                        SET @prevMonth = @actMonth - 1 
                        SET @newPerson = 0
                        SET @counter = 1
                    END
                ELSE
                    BEGIN
                        SET @sumGros = @sumGros + @Gros
                        SET @sumNet = @sumNet + @Net
                        SET @counter = @counter + 1
                    END
            END
            CLOSE historyCursor
            IF(@newPerson = 1 OR @n = 1)
                BEGIN
                    IF(@salaryGros < 120000/(12 - @n))
                        INSERT INTO @result VALUES(@emploID, @salaryGros * (1 - 0.17))
                    ELSE
                        INSERT INTO @result VALUES(@emploID, @salaryGros * (1 - 0.32) - 15300/(13 - @n))
                END

            FETCH NEXT FROM employeesIDCursor INTO @emploID, @salaryGros
        END
    DEALLOCATE historyCursor
    DEALLOCATE employeesIDCursor
    SELECT * FROM @log
    SELECT * FROM @result
END
GO
EXEC salary @n = 1
GO
EXEC salary @n = 2
GO
EXEC salary @n = 3