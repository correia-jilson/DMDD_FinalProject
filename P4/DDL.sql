CREATE TABLE StockInfo (
    StockID INT not null PRIMARY KEY,
    [Name] VARCHAR(20) not null,
    DESCRIPTION VARCHAR(MAX)
);

CREATE TABLE StockPriceInfo (
    StockID INT,
    Date DATE,
    [Open] DECIMAL(10, 2) not null CHECK([Open] > 0.00),
	[Current] DECIMAL(10, 2) not null CHECK([Current] > 0.00),
    [Close] DECIMAL(10, 2),
    Volume INT not null,
	PRIMARY KEY (StockID, Date),
	FOREIGN KEY (StockID) REFERENCES StockInfo(StockID)
);

CREATE TABLE Investor (
    InvestorID INT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    ContactNumber VARCHAR(15) NOT NULL UNIQUE CHECK(ContactNumber LIKE '%[0-9-]%'),
    DOB DATE NOT NULL,
	[Password] VARCHAR(255) not null
);

CREATE TABLE PaymentMethod (
    PaymentMethodID INT PRIMARY KEY,
    InvestorID INT,
    CardNumber VARCHAR(19) NOT NULL UNIQUE,
    CardHolderName VARCHAR(255) NOT NULL,
	CVV CHAR(3) NOT NULL,
    ExpiryDate DATE NOT NULL,
    CardType VARCHAR(50) NOT NULL,
    BillingAddress VARCHAR(255) NOT NULL,
    FOREIGN KEY (InvestorID) REFERENCES Investor(InvestorID)
);

CREATE TABLE Notification (
    NotificationID INT PRIMARY KEY,
    InvestorID INT,
    [Message] TEXT NOT NULL,
    [Date] DATE NOT NULL DEFAULT(GETDATE()),
    FOREIGN KEY (InvestorID) REFERENCES Investor(InvestorID)
);

CREATE TABLE [Platform] (
    PlatformID INT not null PRIMARY KEY,
    [Name] VARCHAR(30) not null,
    ServiceFee DECIMAL(5,2) DEFAULT 0.00 CHECK(ServiceFee >= 0.00),
    MinimumDeposit DECIMAL(10,2) DEFAULT 0.00 CHECK(MinimumDeposit >= 0.00)
);

CREATE TABLE Employee (
    EmployeeID INT not null PRIMARY KEY,
    FirstName VARCHAR(20) not null,
    LastName VARCHAR(20) not null,
    PlatformID INT not null,
    PhoneNumber VARCHAR(20) UNIQUE CHECK (PhoneNumber LIKE '%[0-9-]%'),
    FOREIGN KEY (PlatformID) REFERENCES Platform(PlatformID)
);

CREATE TABLE Account (
    AccountID INT PRIMARY KEY,
    PlatformID INT,
    Balance DECIMAL(10, 2) CHECK(Balance>=0.00),
    InvestorID INT,
    FOREIGN KEY (PlatformID) REFERENCES [Platform](PlatformID),
    FOREIGN KEY (InvestorID) REFERENCES Investor(InvestorID)
);

CREATE TABLE Policy (
    PolicyID INT not null PRIMARY KEY,
    Description VARCHAR(MAX) not null,
    PlatformID INT not null,
    FOREIGN KEY (PlatformID) REFERENCES Platform(PlatformID)
);

CREATE TABLE [Order] (
	OrderID INT PRIMARY KEY not null IDENTITY(1,1),
	AccountID INT not null,
	StockID INT not null,
	Quantity INT not null,
	[Date] DATE not null,
	PurchasePrice AS dbo.GetCurrentStockPrice(StockID, [Date]),
	TotalExpense AS (dbo.GetCurrentStockPrice(StockID, [Date]) * Quantity * (1 + dbo.GetServiceFee(AccountID))),
	FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
	FOREIGN KEY (StockID, [Date]) REFERENCES StockPriceInfo(StockID, [Date]),
	CONSTRAINT CHK_Quantity CHECK (dbo.CheckQuantityConstraint(StockID, [Date], Quantity) = 1),
	CONSTRAINT CHK_TotalExpense CHECK (
		dbo.GetCurrentStockPrice(StockID, [Date]) * Quantity * (1 + dbo.GetServiceFee(AccountID)) <= dbo.GetAccountBalance(AccountID)
	)
);

CREATE TABLE TransactionHistory (
    TransactionID INT PRIMARY KEY,
    source_AccountID INT not null,
    money_amount DECIMAL(10, 2) CHECK(money_amount > 0.00),
    transaction_date DATE DEFAULT(GETDATE()),
    destination_AccountID INT not null,
    FOREIGN KEY (source_AccountID) REFERENCES Account(AccountID),
    FOREIGN KEY (destination_AccountID) REFERENCES Account(AccountID),
	CONSTRAINT CHK_AccountBalance CHECK (dbo.GetAccountBalance(source_AccountID) >= money_amount)
);

CREATE TABLE Portfolio (
    PortfolioID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT not null,
    NumberOfRecords INT,
    TotalAssets DECIMAL(10, 2),
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE PortfolioRecord (
    PortfolioID INT not null,
    StockID INT not null,
	[Date] DATE not null,
    Quantity INT not null,
    PurchasePrice DECIMAL(10, 2) not null,
	[TotalValue] AS (Quantity * PurchasePrice),
	PRIMARY KEY (PortfolioID, StockID, [Date]),
    FOREIGN KEY (PortfolioID) REFERENCES Portfolio(PortfolioID),
    FOREIGN KEY (StockID, [Date]) REFERENCES StockPriceInfo(StockID, [Date]),
);

CREATE TABLE Watchlist (
    WatchlistID INT not null PRIMARY KEY,
    InvestorID INT not null,
    Listname VARCHAR(50),
    FOREIGN KEY (InvestorID) REFERENCES Investor(InvestorID)
);

CREATE TABLE WatchlistRecord (
    WatchlistID INT not null,
    StockID INT not null,
    AddDate DATE DEFAULT(GETDATE()),
	PRIMARY KEY (WatchlistID, StockID),
    FOREIGN KEY (WatchlistID) REFERENCES Watchlist(WatchlistID),
    FOREIGN KEY (StockID) REFERENCES StockInfo(StockID)
);


