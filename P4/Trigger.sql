-- Create trigger for insert on PortfolioRecord
CREATE TRIGGER trgPortfolioRecord_Insert
ON PortfolioRecord
AFTER INSERT
AS
BEGIN
	 -- Declare variables to store inserted row values
    DECLARE @InsertedPortfolioID INT;
    
    -- Declare cursor to iterate over inserted rows
    DECLARE cursorInserted CURSOR FOR
    SELECT PortfolioID FROM inserted;

    -- Open the cursor
    OPEN cursorInserted;

    -- Fetch the first row
    FETCH NEXT FROM cursorInserted INTO @InsertedPortfolioID;

    -- Start looping through the inserted rows
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Update NumberOfRecords and TotalAssets in Portfolio table for each inserted PortfolioID
        UPDATE Portfolio
        SET NumberOfRecords = dbo.GetNumberOfRecords(@InsertedPortfolioID),
            TotalAssets = dbo.GetTotalAssets(@InsertedPortfolioID)
        WHERE PortfolioID = @InsertedPortfolioID;
        
        -- Fetch the next row
        FETCH NEXT FROM cursorInserted INTO @InsertedPortfolioID;
    END;

    -- Close and deallocate the cursor
    CLOSE cursorInserted;
    DEALLOCATE cursorInserted;
END;
GO

-- Create trigger for update on PortfolioRecord
CREATE TRIGGER trgPortfolioRecord_Update
ON PortfolioRecord
AFTER UPDATE
AS
BEGIN
    DECLARE @PortfolioID INT;
    
    -- Get PortfolioID from updated records
    SELECT @PortfolioID = PortfolioID FROM inserted;
    
    -- Update NumberOfRecords and TotalAssets in Portfolio table
    UPDATE Portfolio
    SET NumberOfRecords = dbo.GetNumberOfRecords(@PortfolioID),
        TotalAssets = dbo.GetTotalAssets(@PortfolioID)
    WHERE PortfolioID = @PortfolioID;
END;
GO

-- Create trigger for delete on PortfolioRecord
CREATE TRIGGER trgPortfolioRecord_Delete
ON PortfolioRecord
AFTER DELETE
AS
BEGIN
    DECLARE @PortfolioID INT;
    
    -- Get PortfolioID from deleted records
    SELECT @PortfolioID = PortfolioID FROM deleted;
    
    -- Update NumberOfRecords and TotalAssets in Portfolio table
    UPDATE Portfolio
    SET NumberOfRecords = dbo.GetNumberOfRecords(@PortfolioID),
        TotalAssets = dbo.GetTotalAssets(@PortfolioID)
    WHERE PortfolioID = @PortfolioID;
END;
GO

-- Create trigger for insert on Order
CREATE TRIGGER trgInsertOnOrder
ON [Order]
AFTER INSERT
AS
BEGIN
    DECLARE @AccountID INT, @TotalExpense DECIMAL(10, 2), @StockID INT, @Date DATE, @Quantity INT;

    -- Get inserted values
    SELECT @AccountID = i.AccountID,
           @TotalExpense = i.TotalExpense,
           @StockID = i.StockID,
           @Date = i.[Date],
           @Quantity = i.Quantity
    FROM inserted i;

    -- Update account balance
    UPDATE Account
    SET Balance = Balance - @TotalExpense
    WHERE AccountID = @AccountID;

    -- Update stock price info volume
    UPDATE StockPriceInfo
    SET Volume = Volume - @Quantity
    WHERE StockID = @StockID AND [Date] = @Date;

    -- Insert corresponding records into PortfolioRecord
    INSERT INTO PortfolioRecord (PortfolioID, StockID, [Date], Quantity, PurchasePrice)
    SELECT p.PortfolioID, i.StockID, i.[Date], i.Quantity, i.PurchasePrice
    FROM inserted i
    JOIN Account a ON i.AccountID = a.AccountID
    JOIN Portfolio p ON a.AccountID = p.AccountID;
END;
GO

CREATE TRIGGER trgUpdateAccountBalance
ON TransactionHistory
AFTER INSERT
AS
BEGIN
    -- Subtracting money from the source account
    UPDATE Account
    SET Balance = Balance - i.money_amount
    FROM Account
    INNER JOIN inserted i ON Account.AccountID = i.source_AccountID;

    -- Adding money to the destination account
    UPDATE Account
    SET Balance = Balance + i.money_amount
    FROM Account
    INNER JOIN inserted i ON Account.AccountID = i.destination_AccountID;
END;
GO

CREATE TRIGGER trgInitialAccountBalance
ON Account
AFTER INSERT
AS
BEGIN
    -- Subtracting money from the source account
    UPDATE Account
    SET Balance = dbo.GetMinimumDeposit(PlatformID)
    FROM Account

END;
GO

CREATE TRIGGER trgCreatePortfolio
ON Account
AFTER INSERT
AS
BEGIN
	
	-- Create a portfolio accordingly
    INSERT INTO Portfolio(AccountID, NumberOfRecords, TotalAssets)
	SELECT i.AccountID, 0, 0.00
	FROM inserted i

END;
