CREATE PROCEDURE GetInvestorPortfolioValue
    @InvestorID INT,
    @TotalPortfolioValue DECIMAL(10, 2) OUTPUT
AS
BEGIN
    SELECT @TotalPortfolioValue = SUM(TotalAssets)
    FROM Portfolio
    JOIN Account ON Portfolio.AccountID = Account.AccountID
    WHERE Account.InvestorID = @InvestorID
END
GO

CREATE PROCEDURE UpdateStockPrice
    @StockID INT,
    @NewCurrentPrice DECIMAL(10, 2),
    @OldCurrentPrice DECIMAL(10, 2) OUTPUT
AS
BEGIN
    -- Get the current price before updating
    SELECT TOP 1 @OldCurrentPrice = [Current]
    FROM StockPriceInfo
    WHERE StockID = @StockID
    ORDER BY Date DESC;

    -- Update the current price
    UPDATE StockPriceInfo
    SET [Current] = @NewCurrentPrice
    WHERE StockID = @StockID
    AND Date = (SELECT MAX(Date) FROM StockPriceInfo WHERE StockID = @StockID);
END

GO

CREATE PROCEDURE AddTransactionHistory
    @SourceAccountID INT,
    @DestinationAccountID INT,
    @MoneyAmount DECIMAL(10, 2),
    @TransactionDate DATE,
    @ResultMessage VARCHAR(255) OUTPUT
AS
BEGIN
    DECLARE @SourceBalance DECIMAL(10, 2);

    SELECT @SourceBalance = Balance
    FROM Account
    WHERE AccountID = @SourceAccountID;

    IF @SourceBalance >= @MoneyAmount
    BEGIN
        INSERT INTO TransactionHistory(source_AccountID, destination_AccountID, money_amount, transaction_date)
        VALUES(@SourceAccountID, @DestinationAccountID, @MoneyAmount, @TransactionDate);

        -- Update the source account balance
        UPDATE Account
        SET Balance = Balance - @MoneyAmount
        WHERE AccountID = @SourceAccountID;

        -- Update the destination account balance
        UPDATE Account
        SET Balance = Balance + @MoneyAmount
        WHERE AccountID = @DestinationAccountID;

        SET @ResultMessage = 'Transaction completed successfully.';
    END
    ELSE
    BEGIN
        SET @ResultMessage = 'Transaction failed: Insufficient funds.';
    END
END