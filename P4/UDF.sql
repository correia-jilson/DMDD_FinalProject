GO
CREATE FUNCTION dbo.GetNumberOfRecords 
(
	@PortfolioID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;
    SELECT @Count = COUNT(*) FROM PortfolioRecord p WHERE p.PortfolioID = @PortfolioID;
    RETURN @Count;
END;
GO

CREATE FUNCTION dbo.GetTotalAssets 
(
	@PortfolioID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);
    SELECT @Total = SUM(TotalValue) FROM PortfolioRecord p WHERE p.PortfolioID = @PortfolioID;
    RETURN @Total;
END;
GO

CREATE FUNCTION dbo.GetMinimumDeposit
(
	@PlatformID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
	DECLARE @MinDeposit DECIMAL(10,2);
	SELECT @MinDeposit = MinimumDeposit FROM [Platform] p WHERE p.PlatformID = @PlatformID;
	RETURN @MinDeposit;
END
GO

CREATE FUNCTION dbo.GetServiceFee
(
	@AccountID INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
	DECLARE @ServiceFee DECIMAL(5,2);
	SELECT @ServiceFee = p.ServiceFee 
	FROM [Platform] p JOIN Account a ON a.PlatformID = p.PlatformID
	WHERE a.AccountID = @AccountID;
	
	RETURN @ServiceFee;
END
GO

CREATE FUNCTION dbo.GetAccountBalance 
(
	@AccountID INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @Balance DECIMAL(10, 2);

    SELECT @Balance = Balance
    FROM Account
    WHERE AccountID = @AccountID;

    RETURN @Balance;
END;
GO

CREATE FUNCTION dbo.GetCurrentStockPrice
(
    @StockID INT,
    @Date DATE
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @CurrentValue DECIMAL(10, 2);

    SELECT @CurrentValue = [Current]
    FROM StockPriceInfo
    WHERE StockID = @StockID AND [Date] = @Date;

    RETURN @CurrentValue;
END;
GO

CREATE FUNCTION dbo.CheckQuantityConstraint 
(
	@StockID INT, @Date DATE, @Quantity INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT;

    IF EXISTS (
        SELECT 1
        FROM StockPriceInfo s
        WHERE s.StockID = @StockID 
        AND s.Date = @Date 
        AND @Quantity > 0 
        AND @Quantity <= s.Volume
    )
    BEGIN
        SET @IsValid = 1;
    END
    ELSE
    BEGIN
        SET @IsValid = 0;
    END

    RETURN @IsValid;
END;