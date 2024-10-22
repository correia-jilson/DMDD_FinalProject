CREATE VIEW InvestorPortfolioOverview AS
SELECT
    Investor.InvestorID,
    Investor.FirstName + ' ' + Investor.LastName AS FullName,
    Account.AccountID,
    Portfolio.NumberOfRecords,
    Portfolio.TotalAssets
FROM
    Investor
INNER JOIN
    Account ON Investor.InvestorID = Account.InvestorID
INNER JOIN
    Portfolio ON Account.AccountID = Portfolio.AccountID;
GO

CREATE VIEW StockPerformanceSummary AS
SELECT
    StockInfo.StockID,
    StockInfo.Name,
    LATEST.[Date],
    LATEST.[Open],
    LATEST.[Current],
    LATEST.[Close],
    LATEST.Volume
FROM
    StockInfo
OUTER APPLY (
    SELECT TOP 1
        StockPriceInfo.[Date],
        StockPriceInfo.[Open],
        StockPriceInfo.[Current],
        StockPriceInfo.[Close],
        StockPriceInfo.Volume
    FROM
        StockPriceInfo
    WHERE
        StockPriceInfo.StockID = StockInfo.StockID
    ORDER BY
        StockPriceInfo.[Date] DESC
) AS LATEST;
GO

CREATE VIEW RecentTransactions AS
SELECT TOP (100) PERCENT
    th.TransactionID,
    sa.AccountID AS SourceAccount,
    da.AccountID AS DestinationAccount,
    th.money_amount,
    th.transaction_date,
    s.FirstName + ' ' + s.LastName AS SourceInvestorName,
    d.FirstName + ' ' + d.LastName AS DestinationInvestorName
FROM
    TransactionHistory th
INNER JOIN
    Account sa ON th.source_AccountID = sa.AccountID
INNER JOIN
    Investor s ON sa.InvestorID = s.InvestorID
INNER JOIN
    Account da ON th.destination_AccountID = da.AccountID
INNER JOIN
    Investor d ON da.InvestorID = d.InvestorID
ORDER BY
    th.transaction_date DESC;
