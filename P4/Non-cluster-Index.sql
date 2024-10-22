--Index on StockPriceInfo for Date-Based Queries
CREATE NONCLUSTERED INDEX IDX_StockPriceInfo_Date
ON StockPriceInfo (Date);

--Index on TransactionHistory for Source and Destination AccountID
 CREATE NONCLUSTERED INDEX IDX_TransactionHistory_Accounts
ON TransactionHistory (source_AccountID, destination_AccountID);

--Composite Index on Order for AccountID and Date
CREATE NONCLUSTERED INDEX IDX_Order_AccountID_Date
ON [Order] (AccountID, [Date]);