-- Create a new database

USE Blockchain;
-- Create the Blocks table
Create table Blocks (
    BlockID INT PRIMARY KEY IDENTITY(1,1),
    Timestamp DATETIME NOT NULL,
    PreviousBlockHash VARCHAR(64) NOT NULL,
    MerkleRoot VARCHAR(64) NOT NULL,
    Nonce INT NOT NULL
);
select * from Blocks
select * from Accounts
-- Create the Accounts table
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    AccountAddress VARCHAR(255) NOT NULL,
    Balance DECIMAL(18, 8) NOT NULL,
    PublicKey VARCHAR(MAX),
    PrivateKey VARCHAR(MAX),
    TransactionHistory VARCHAR(MAX)
);


-- Create the SmartContracts table
CREATE TABLE SmartContracts (
    ContractID INT PRIMARY KEY IDENTITY(1,1),
    ContractAddress VARCHAR(255) NOT NULL,
    ContractCode VARCHAR(MAX) NOT NULL,
    ContractCreator VARCHAR(255) NOT NULL,
    ContractCreationDate DATETIME NOT NULL,
);
select * from Blocks
-- Create the Transactions table (without foreign keys)
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    SenderAccountID INT,
    ReceiverAccountID INT,
    BlockID INT NOT NULL,
	Amount DECIMAL(18, 8) NOT NULL,
    TransactionTimestamp DATETIME NOT NULL,
);
select * from Transactions
ALTER TABLE Transactions
ADD CONSTRAINT fk_SenderAccountID
FOREIGN KEY(SenderAccountID) REFERENCES Accounts(AccountID);

ALTER TABLE Transactions
ADD CONSTRAINT fk_ReceiverAccountID
FOREIGN KEY(ReceiverAccountID) REFERENCES Accounts(AccountID);

-- Create the Miners table
CREATE TABLE Miners (
    MinerID INT PRIMARY KEY IDENTITY(1,1),
    BlockID INT NOT NULL,
    RewardAmount DECIMAL(18, 8) NOT NULL,
    MinerAddress VARCHAR(255) NOT NULL
	foreign key (BlockID) references Blocks(BlockID)
);

-- Create the BlockchainMetadata table
CREATE TABLE BlockchainMetadata (
    MetadataID INT PRIMARY KEY IDENTITY(1,1),
    BlockchainName VARCHAR(255) NOT NULL,
    NetworkID VARCHAR(50) NOT NULL,
    GenesisBlockInfo VARCHAR(MAX) NOT NULL,
    ConsensusAlgorithm VARCHAR(50) NOT NULL,
    BlockTime INT NOT NULL
);
SELECT * FROM dbo.Transactions;
SELECT SenderAccountID, ReceiverAccountID FROM dbo.Transactions;


-- Create the Security and Access Control table
CREATE TABLE SecurityAccess (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    UserName VARCHAR(50) NOT NULL,
    PasswordHash VARCHAR(MAX) NOT NULL,
    UserRole VARCHAR(50) NOT NULL
	
);

-- Create a table for Transaction Inputs (simplified)
CREATE TABLE TransactionInputs (
    InputID INT PRIMARY KEY IDENTITY(1,1),
    TransactionID INT NOT NULL,
    OutputTransactionID INT NOT NULL,
    InputAmount DECIMAL(18, 8) NOT NULL
	foreign key (TransactionID) references Transactions(TransactionID)
);

-- Create a table for Transaction Outputs (simplified)
CREATE TABLE TransactionOutputs (
    OutputID INT PRIMARY KEY IDENTITY(1,1),
    TransactionID INT NOT NULL,
    ReceiverAccountID INT NOT NULL,
    OutputAmount DECIMAL(18, 8) NOT NULL
	foreign key (TransactionID) references Transactions(TransactionID),
	foreign key (ReceiverAccountID) references Accounts(AccountID)
);

-- Create a table for Tokens (simplified)
CREATE TABLE Tokens (
    TokenID INT PRIMARY KEY IDENTITY(1,1),
    TokenName VARCHAR(50) NOT NULL,
    TokenSymbol VARCHAR(10) NOT NULL,
    TotalSupply DECIMAL(18, 8) NOT NULL
);

-- Create a junction table for the m:n relationship between Accounts and SmartContracts
CREATE TABLE AccountSmartContract (
    AccountID INT,
    ContractID INT,
    CONSTRAINT PK_AccountSmartContract PRIMARY KEY (AccountID, ContractID),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    FOREIGN KEY (ContractID) REFERENCES SmartContracts(ContractID)
);

-- Define primary key for UserTransactions
CREATE TABLE UserTransactions (
    UserTransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT NOT NULL,
    TransactionID INT NOT NULL,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID)
);

-- Define primary key for ContractExecutions
CREATE TABLE ContractExecutions (
    ContractExecutionID INT PRIMARY KEY IDENTITY(1,1),
    ContractID INT NOT NULL,
    ExecutionTimestamp DATETIME NOT NULL,
    FOREIGN KEY (ContractID) REFERENCES SmartContracts(ContractID)
);

INSERT INTO UserTransactions (AccountID, TransactionID)
VALUES
    (1, 1),
    (2, 2);

-- Sample data for ContractExecutions
INSERT INTO ContractExecutions (ContractID, ExecutionTimestamp)
VALUES
    (1, '2023-10-18 14:00:00'),
    (2, '2023-10-19 15:00:00');

-- Your existing code for example tables ...
select * from Accounts;
-- Inserting example data into the Accounts table
INSERT INTO Accounts (AccountAddress, Balance, PublicKey, PrivateKey, TransactionHistory)
VALUES
    ('Address_1', 100.0, 'PubKey_1', 'PrivKey_1', 'History_1'),
    ('Address_2', 250.0, 'PubKey_2', 'PrivKey_2', 'History_2'),
    ('Address_3', 500.0, 'PubKey_3', 'PrivKey_3', 'History_3');
select * from Accounts

-- Inserting example data into the SmartContracts table
INSERT INTO SmartContracts (ContractAddress, ContractCode, ContractCreator, ContractCreationDate)
VALUES
    ('Contract_Address_1', 'Contract_Code_1', 'Creator_1', '2023-10-20 10:00:00'),
    ('Contract_Address_2', 'Contract_Code_2', 'Creator_2', '2023-10-21 11:00:00'),
    ('Contract_Address_3', 'Contract_Code_3', 'Creator_3', '2023-10-22 12:00:00');

select * from SmartContracts

INSERT INTO Blocks (Timestamp, PreviousBlockHash, MerkleRoot, Nonce)
VALUES
    ('2023-10-27 18:00:00', 'Hash_1', 'Merkle_Root_1', 12345),
    ('2023-10-28 19:00:00', 'Hash_2', 'Merkle_Root_2', 54321);
select * from Blocks

INSERT INTO AccountSmartContract (AccountID, ContractID)
VALUES
    (1, 1),  -- AccountID 1 associated with ContractID 1
    (1, 2),  -- AccountID 1 associated with ContractID 2
    (2, 2);  -- AccountID 2 associated with ContractID 2 (for example)
select * from AccountSmartContract
select * from Transactions
-- Violate referential integrity constraint
-- Attempt to insert a Transaction without a valid SenderAccountID
INSERT INTO Transactions (SenderAccountID, ReceiverAccountID, BlockID, Amount, TransactionTimestamp)
VALUES
    (100, 2, 1, 10.0, '2023-10-17 12:00:00'); -- Violates referential integrity
select * from Transactions
-- Insert data into UserTransactions
INSERT INTO UserTransactions (AccountID, TransactionID)
VALUES
    (2, 3),
    (3, 4);

-- Update data for at least 3 tables
------------------------------------------------------------------------------------------------
--												A2
-- Update Account balance
UPDATE Accounts
SET Balance = Balance + 50.0
WHERE AccountID = 1;

-- Update SmartContract creator
UPDATE SmartContracts
SET ContractCreator = 'NewCreator'
WHERE ContractID = 1;

-- Update Transaction amount
UPDATE Transactions
SET Amount = Amount + 5.0
WHERE TransactionID = 1;

-- Delete data for at least 2 tables

-- Delete a specific UserTransaction
DELETE FROM UserTransactions
WHERE UserTransactionID = 1;

-- Delete a specific ContractExecution
DELETE FROM ContractExecutions
WHERE ContractExecutionID = 1;

-- Queries

-- a. 2 queries with the union operation
-- Using UNION ALL
SELECT AccountID FROM UserTransactions
UNION ALL
SELECT AccountID FROM AccountSmartContract;

-- Using UNION with OR
SELECT AccountID FROM UserTransactions
UNION
SELECT AccountID FROM AccountSmartContract
WHERE ContractID = 1;

-- b. 2 queries with the intersection operation
-- Using INTERSECT
SELECT AccountID FROM UserTransactions
INTERSECT
SELECT AccountID FROM AccountSmartContract;
select * from UserTransactions
select * from AccountSmartContract
-- Using IN with intersection
SELECT AccountID FROM UserTransactions
WHERE AccountID IN (SELECT AccountID FROM AccountSmartContract WHERE ContractID = 1);

-- c. 2 queries with the difference operation
-- Using EXCEPT
SELECT AccountID FROM UserTransactions
EXCEPT
SELECT AccountID FROM AccountSmartContract;

-- Using NOT IN with difference
SELECT AccountID FROM UserTransactions
WHERE AccountID NOT IN (SELECT AccountID FROM AccountSmartContract);

-- Inserting data into Accounts table
INSERT INTO Accounts (AccountAddress, Balance, PublicKey, PrivateKey, TransactionHistory)
VALUES
    ('Address_1', 100.0, 'PubKey_1', 'PrivKey_1', 'History_1'),
    ('Address_2', 250.0, 'PubKey_2', 'PrivKey_2', 'History_2'),
    ('Address_3', 500.0, 'PubKey_3', 'PrivKey_3', 'History_3');

-- Inserting data into SmartContracts table
INSERT INTO SmartContracts (ContractAddress, ContractCode, ContractCreator, ContractCreationDate)
VALUES
    ('Contract_Address_1', 'Contract_Code_1', 'Creator_1', '2023-10-20 10:00:00'),
    ('Contract_Address_2', 'Contract_Code_2', 'Creator_2', '2023-10-21 11:00:00'),
    ('Contract_Address_3', 'Contract_Code_3', 'Creator_3', '2023-10-22 12:00:00');

-- Inserting data into Transactions table (violating referential integrity)
INSERT INTO Transactions (SenderAccountID, ReceiverAccountID, BlockID, Amount, TransactionTimestamp)
VALUES
    (10, 20, 5, 150.0, '2023-10-25 16:00:00'), -- Non-existent AccountID used
    (4, 3, 2, 20.0, '2023-10-26 17:00:00');
-- Inserting data into AccountSmartContract table
INSERT INTO AccountSmartContract (AccountID, ContractID)
VALUES
    (1, 1),  -- AccountID 1 associated with ContractID 1
    (1, 2),  -- AccountID 1 associated with ContractID 2
    (2, 2);  -- AccountID 2 associated with ContractID 2 (for example)

-- Inserting data into Blocks table
INSERT INTO Blocks (Timestamp, PreviousBlockHash, MerkleRoot, Nonce)
VALUES
    ('2023-10-27 18:00:00', 'Hash_1', 'Merkle_Root_1', 12345),
    ('2023-10-28 19:00:00', 'Hash_2', 'Merkle_Root_2', 54321);

-- Update data in Accounts table
UPDATE Accounts
SET Balance = 300.0
WHERE AccountID = 1;

-- Update data in SmartContracts table
UPDATE SmartContracts
SET ContractCode = 'Updated_Code'
WHERE ContractID = 2;

-- Update data in Transactions table
UPDATE Transactions
SET Amount = 25.0
WHERE TransactionID = 1;

-- Delete data from SmartContracts table
DELETE FROM SmartContracts
WHERE ContractID = 3;

-- Delete data from Transactions table
DELETE FROM Transactions
WHERE Amount BETWEEN 10.0 AND 20.0;

-- Query 1: Using UNION ALL
SELECT AccountAddress FROM Accounts
UNION ALL
SELECT ContractAddress FROM SmartContracts;
select * from Accounts
-- Query 2: Using OR
SELECT AccountAddress FROM Accounts
WHERE AccountID = 1
OR Balance > 200.0;
select * from AccountSmartContract
-- Query 1: Using INTERSECT
SELECT AccountID FROM Accounts
INTERSECT
SELECT AccountID FROM AccountSmartContract;

-- Query 2: Using EXCEPT
SELECT AccountID FROM Accounts
EXCEPT
SELECT AccountID FROM AccountSmartContract;

-- Query 3: Using IN
/*Retrieves AccountID from the Accounts table 
where the AccountID exists in the result set obtained from the subquery.*/
SELECT AccountID FROM Accounts
WHERE AccountID IN (SELECT AccountID FROM AccountSmartContract);

-- Query 4: Using NOT IN
SELECT AccountID FROM Accounts
WHERE AccountID NOT IN (SELECT AccountID FROM AccountSmartContract);

-- Query 1: INNER JOIN with 3 tables
/*Retrieves all columns from the Accounts, Transactions, and Blocks tables 
where there are matching AccountID, SenderAccountID, and BlockID.*/
SELECT *
FROM Accounts AS A
INNER JOIN Transactions AS T ON A.AccountID = T.SenderAccountID
INNER JOIN Blocks AS B ON T.BlockID = B.BlockID;

-- Query 2: LEFT JOIN with many-to-many relationships
/*Fetches all columns from the Accounts, AccountSmartContract, and SmartContracts tables, 
linking AccountID and ContractID.*/
SELECT *
FROM Accounts AS A
LEFT JOIN AccountSmartContract AS ASC_T ON A.AccountID = ASC_T.AccountID
LEFT JOIN SmartContracts AS SC ON ASC_T.ContractID = SC.ContractID;

-- Query 3: RIGHT JOIN with 2 tables
/* Retrieves all columns from the SmartContracts, AccountSmartContract, and 
Accounts tables, linking ContractID and AccountID.*/
SELECT *
FROM SmartContracts AS SC
RIGHT JOIN AccountSmartContract AS ASC_T ON SC.ContractID = ASC_T.ContractID
RIGHT JOIN Accounts AS A ON ASC_T.AccountID = A.AccountID;

-- Query 4: FULL JOIN with 3 tables
/*Fetches all columns from the Accounts, Transactions, and Blocks tables with 
a full join on AccountID, SenderAccountID, and BlockID.*/
SELECT *
FROM Accounts AS A
FULL JOIN Transactions AS T ON A.AccountID = T.SenderAccountID
FULL JOIN Blocks AS B ON T.BlockID = B.BlockID;

-- Query 1: IN operator with a subquery
/*Retrieves all columns from the Accounts table where AccountID exists 
in the subquery nested within the WHERE clause.*/
SELECT *
FROM Accounts
WHERE AccountID IN (
    SELECT AccountID
    FROM Transactions
    WHERE SenderAccountID IN (
        SELECT AccountID
        FROM AccountSmartContract
        WHERE ContractID = 1
    )
);

-- Query 2: IN operator with a subquery including its own WHERE clause
/*Retrieves all columns from the SmartContracts table where ContractID exists in a subquery. 
The subquery filters AccountID from the Transactions table based on SenderAccountID being equal to 1.*/
SELECT *
FROM SmartContracts
WHERE ContractID IN (
    SELECT ContractID
    FROM AccountSmartContract
    WHERE AccountID IN (
        SELECT AccountID
        FROM Transactions
        WHERE SenderAccountID = 1
    )
);
-- Query 3: EXISTS operator with a subquery
/*Retrieves all columns from the Accounts table where a correlated subquery checks 
if there exists a record in the Transactions table where the SenderAccountID matches the AccountID.*/
SELECT *
FROM Accounts AS A
WHERE EXISTS (
    SELECT *
    FROM Transactions AS T
    WHERE T.SenderAccountID = A.AccountID
);
-- Query 4: EXISTS operator with a subquery including its own WHERE clause
/*Retrieves all columns from the Transactions table where a correlated subquery checks 
if there exists a record in the Blocks table and another correlated subquery checks if 
there exists a record in the Miners table with certain conditions 
(BlockID matches and RewardAmount is greater than 5.0).*/
SELECT *
FROM Transactions AS T
WHERE EXISTS (
    SELECT *
    FROM Blocks AS B
    WHERE B.BlockID = T.BlockID
    AND EXISTS (
        SELECT *
        FROM Miners AS M
        WHERE M.BlockID = B.BlockID
        AND M.RewardAmount > 5.0
    )
);

-- Query 1: Subquery in the FROM clause
/*Uses a subquery to obtain AccountAddress and Balance from the Accounts table based on a condition 
where Balance is greater than the average balance in the Accounts table*/
SELECT *
FROM (
    SELECT AccountAddress, Balance
    FROM Accounts
    WHERE Balance > (
        SELECT AVG(Balance)
        FROM Accounts
    )
) AS SubqueryResult;
-- Query 2: Subquery in the FROM clause with JOIN
/*Uses a subquery to join AccountID from the Accounts table with 
ContractID from the AccountSmartContract table.*/
SELECT *
FROM (
    SELECT A.AccountID, S.ContractID
    FROM Accounts AS A
    INNER JOIN AccountSmartContract AS S ON A.AccountID = S.AccountID
) AS AccountContract;
-- Query 3: GROUP BY with HAVING clause and subquery
/*Groups records by AccountID in the Transactions table and filters out groups 
where the count of transactions is greater than the average count of transactions per account.*/
SELECT AccountID, COUNT(*) AS TransactionCount
FROM Transactions
GROUP BY AccountID
HAVING COUNT(*) > (
    SELECT AVG(TransactionCount)
    FROM (
        SELECT AccountID, COUNT(*) AS TransactionCount
        FROM Transactions
        GROUP BY AccountID
    ) AS TransactionCounts
);
-- Query 4: GROUP BY with HAVING clause and subquery in HAVING clause
/*Groups records by SenderAccountID in the Transactions table and filters out groups 
where the count of transactions is greater than the maximum count of transactions among sender accounts.*/
SELECT AccountID, COUNT(*) AS TransactionCount
FROM Transactions
GROUP BY AccountID
HAVING COUNT(*) > (
    SELECT AVG(CountPerAccount)
    FROM (
        SELECT AccountID, COUNT(*) AS CountPerAccount
        FROM Transactions
        GROUP BY AccountID
    ) AS AvgTransactionCounts
);

-- Query 1: Using ANY with a subquery
/*Retrieves all columns from the Accounts table 
where Balance is greater than any of the balances obtained from a subquery result.*/
SELECT *
FROM Accounts
WHERE Balance > ANY (
    SELECT Balance
    FROM Accounts
    WHERE AccountAddress LIKE 'Address%'
);
-- Query 2: Using ALL with a subquery
/*Retrieves all columns from the Accounts table where 
Balance is greater than all the balances obtained from a subquery result.*/
SELECT *
FROM Accounts
WHERE Balance > ALL (
    SELECT Balance
    FROM Accounts
    WHERE AccountAddress LIKE 'Address%'
);
-- Query 3: Using aggregation operator and IN
/*Retrieves all columns from the Accounts table where 
Balance is greater than the average balance in the Accounts table and 
AccountID exists in the result set obtained from the AccountSmartContract table.*/
SELECT *
FROM Accounts
WHERE Balance > (
    SELECT AVG(Balance)
    FROM Accounts
)
AND AccountID IN (
    SELECT AccountID
    FROM AccountSmartContract
);
-- Query 4: Using aggregation operator and NOT IN
/*Retrieves all columns from the Accounts table where 
Balance is greater than the average balance in the 
Accounts table and AccountID does not exist in the result set obtained from 
the AccountSmartContract table.*/
SELECT *
FROM Accounts
WHERE Balance > (
    SELECT AVG(Balance)
    FROM Accounts
)
AND AccountID NOT IN (
    SELECT AccountID
    FROM AccountSmartContract
);

-- Inserting data into the Accounts table
INSERT INTO Accounts (AccountAddress, Balance, PublicKey, PrivateKey, TransactionHistory)
VALUES
    ('Address_4', 150.0, 'PubKey_4', 'PrivKey_4', 'History_4'), -- This insertion won't violate referential integrity
    ('Address_5', 300.0, 'PubKey_5', 'PrivKey_5', 'History_5'),
    ('Address_6', 400.0, 'PubKey_6', 'PrivKey_6', 'History_6'),
    ('Address_7', 500.0, 'PubKey_7', 'PrivKey_7', 'History_7');

-- Inserting data into the SmartContracts table
INSERT INTO SmartContracts (ContractAddress, ContractCode, ContractCreator, ContractCreationDate)
VALUES
    ('Contract_Address_4', 'Contract_Code_4', 'Creator_4', '2023-10-23 13:00:00'),
    ('Contract_Address_5', 'Contract_Code_5', 'Creator_5', '2023-10-24 14:00:00');

-- Inserting data into the Transactions table (to generate some differences)
INSERT INTO Transactions (SenderAccountID, ReceiverAccountID, BlockID, Amount, TransactionTimestamp)
VALUES
    (1, 4, 3, 25.0, '2023-10-29 20:00:00'),
    (2, 5, 4, 30.0, '2023-10-30 21:00:00'),
    (3, 6, 5, 35.0, '2023-10-31 22:00:00');

-- Inserting data into the Blocks table (to generate some differences)
INSERT INTO Blocks (Timestamp, PreviousBlockHash, MerkleRoot, Nonce)
VALUES
    ('2023-11-01 23:00:00', 'Hash_3', 'Merkle_Root_3', 67890),
    ('2023-11-02 00:00:00', 'Hash_4', 'Merkle_Root_4', 98765);

	-- Inserting data into the Miners table
INSERT INTO Miners (BlockID, RewardAmount, MinerAddress)
VALUES
    (1, 10.0, 'Miner_1_Address'),
    (2, 12.5, 'Miner_2_Address'),
    (2, 15.0, 'Miner_3_Address');

-- Inserting data into the Accounts table
INSERT INTO Accounts (AccountAddress, Balance, PublicKey, PrivateKey, TransactionHistory)
VALUES
    ('Address_8', 150.0, 'PubKey_8', 'PrivKey_8', 'History_8'),
    ('Address_9', 300.0, 'PubKey_9', 'PrivKey_9', 'History_9'),
    ('Address_10', 400.0, 'PubKey_10', 'PrivKey_10', 'History_10'),
    ('Address_11', 500.0, 'PubKey_11', 'PrivKey_11', 'History_11');

----------------------------------------------------------------------------------------------
--											A3
Create table Assignment3w(
	Prime INT NOT NULL
);

insert into Assignment3(Prime) values (1);
CREATE TABLE SchemaVersion (
    VersionNumber INT PRIMARY KEY,
    Description VARCHAR(255)
);
insert into SchemaVersion (VersionNumber, Description) Values (2,'hahahahahahhahaadwadaaaaaaaaaaaaaaaaaaaaaa')
select * from SchemaVersion
CREATE PROCEDURE ChangeColumnType
AS
BEGIN  
    ALTER TABLE Accounts
    ALTER COLUMN Balance FLOAT;
    INSERT INTO SchemaVersion (VersionNumber, Description) VALUES (1, 'Changed Accounts.Balance to FLOAT');
END;
GO
exec ChangeColumnType
select * from SchemaVersion
select * from Accounts
CREATE PROCEDURE RevertV2
AS
BEGIN
    ALTER TABLE Accounts
    ALTER COLUMN Balance DECIMAL(18, 8);
    DELETE FROM SchemaVersion WHERE VersionNumber = 1;  
END;
GO

EXEC RevertV2;
CREATE PROCEDURE AddColumn
AS
BEGIN
    ALTER TABLE Accounts
    ADD TestColumn INT;
    INSERT INTO SchemaVersion (VersionNumber, Description) VALUES (2, 'Added TestColumn to Accounts');
END;
GO
exec AddColumn
select * from Accounts
select * from SchemaVersion
CREATE PROCEDURE RevertV3
AS
BEGIN
    ALTER TABLE Accounts
    DROP COLUMN TestColumn;
    DELETE FROM SchemaVersion WHERE VersionNumber = 2;
END;
GO
exec RevertV3

CREATE PROCEDURE AddDefaultConstraint
AS
BEGIN
    ALTER TABLE Accounts
    ADD CONSTRAINT DF_Accounts_Balance DEFAULT 0 FOR Balance;
    INSERT INTO SchemaVersion (VersionNumber, Description) VALUES (3, 'Added DEFAULT constraint to Accounts.Balance');
END;
GO
exec AddDefaultConstraint
CREATE PROCEDURE RevertV4
AS
BEGIN
    ALTER TABLE Accounts
    DROP CONSTRAINT DF_Accounts_Balance;
    DELETE FROM SchemaVersion WHERE VersionNumber = 3;
END;
GO
exec RevertV4
exec RemoveDefaultConstraint
CREATE PROCEDURE AddPrimaryKey
AS
BEGIN
    ALTER TABLE Assignment3w
    ADD CONSTRAINT PK_Assignment3w PRIMARY KEY (Prime);
    INSERT INTO SchemaVersion (VersionNumber, Description) VALUES (4, 'Added PRIMARY KEY to Accounts');
END;
GO
exec AddPrimaryKey
CREATE PROCEDURE RevertV5
AS
BEGIN
    ALTER TABLE Assignment3w
    DROP CONSTRAINT PK_Assignment3w;
    DELETE FROM SchemaVersion WHERE VersionNumber = 4;
END;
GO
exec RevertV5
select * from SchemaVersion
CREATE PROCEDURE AddCandidateKey
AS
BEGIN
    CREATE UNIQUE INDEX UX_Accounts_AccountAddress ON Accounts (AccountAddress);
    INSERT INTO SchemaVersion (VersionNumber, Description) VALUES (5, 'Added candidate key to Accounts.AccountAddress');
END;
GO
exec AddCandidateKey
CREATE PROCEDURE RevertV6
AS
BEGIN
    DROP INDEX UX_Accounts_AccountAddress ON Accounts;
    DELETE FROM SchemaVersion WHERE VersionNumber = 5;
END;
GO
exec RevertV6

CREATE OR ALTER PROCEDURE AddForeignKeyToTokensss
AS
BEGIN
    -- Add a foreign key constraint to the Tokens table referencing UserTransactions table
    ALTER TABLE ContractExecutions
    DROP CONSTRAINT ContractID

    -- Update the SchemaVersion table to reflect the changes
    INSERT INTO SchemaVersion (VersionNumber, Description) VALUES (7, 'Added FOREIGN KEY to Tokens.TokenID referencing UserTransactions.TokenID');
END;
GO

EXEC AddForeignKeyToTokensss;

CREATE PROCEDURE RemoveForeignKeyFromTokens
AS
BEGIN
    -- Drop the foreign key constraint from the Tokens table
    ALTER TABLE Tokens
    DROP CONSTRAINT FK_Tokens_UserTransactions;

    -- Remove the entry for this change from SchemaVersion table
    DELETE FROM SchemaVersion WHERE VersionNumber = 8;
END;
GO



exec RevertV7
select * from SchemaVersion
CREATE PROCEDURE CreateTable
AS
BEGIN
    CREATE TABLE TestTable (
        TestID INT PRIMARY KEY IDENTITY(1,1),
        TestColumn VARCHAR(255) NOT NULL
    );
    INSERT INTO SchemaVersion (VersionNumber, Description) VALUES (7, 'Created TestTable');
END;
GO
exec CreateTable
select * from TestTable
CREATE PROCEDURE DropTable
AS
BEGIN
    DROP TABLE TestTable;
    DELETE FROM SchemaVersion WHERE VersionNumber = 7;
END;
GO
exec DropTable
/*CREATE PROCEDURE SetDatabaseVersions (@TargetVersion INT)
AS
BEGIN
    DECLARE @CurrentVersion INT;
    SELECT @CurrentVersion = MAX(VersionNumber) FROM SchemaVersion;
    DECLARE @Command NVARCHAR(1000);

    WHILE @CurrentVersion > @TargetVersion
    BEGIN
        SET @Command = N'EXEC RevertV' + CAST(@CurrentVersion AS NVARCHAR);
        EXEC sp_executesql @Command;
        SET @CurrentVersion = @CurrentVersion - 1;
    END

    WHILE @CurrentVersion < @TargetVersion
    BEGIN
        SET @CurrentVersion = @CurrentVersion + 1;
        SET @Command = N'EXEC ApplyV' + CAST(@CurrentVersion AS NVARCHAR);
        EXEC sp_executesql @Command;
    END
END;
GO*/
IF OBJECT_ID('dbo.VersionChanged', 'U') IS NOT NULL
	DROP TABLE dbo.VersionChanged;
GO

-- Create a new table for versioning
CREATE TABLE VersionChanged (
	currentProcedure NVARCHAR(100),
	backwardsProcedure NVARCHAR(100),
	versionTO INT UNIQUE
);
GO

-- Populate the VersionChanged table with procedure names and versions
INSERT INTO VersionChanged (currentProcedure, backwardsProcedure, versionTO)
VALUES 
	('ChangeColumnType', 'RevertV2', 1),
	('AddColumn', 'RevertV3', 2),
	('AddDefaultConstraint', 'RevertV4', 3),
	('AddPrimaryKeyyy', 'RevertV5', 4),
	('AddCandidateKey', 'RevertV6', 5),
	/*('AddForeignKey', 'RevertV7', 6),*/
	('CreateTable', 'DropTable', 6);
GO
exec RevertV2
exec RevertV3
exec RevertV4
exec RevertV5
exec RevertV6
exec RevertV7
exec DropTable
select * from VersionChanged
drop TABLE CurrentVersion
CREATE TABLE CurrentVersion
	(currentVersion INT DEFAULT 0)
INSERT INTO CurrentVersion VALUES(0)
select * from CurrentVersion
CREATE OR ALTER PROCEDURE goToVersion(@version INT)
AS
BEGIN
	DECLARE @currentVersion INT
	IF @version < 0 OR @version > 7   -- check if the parameter is ok
		BEGIN
			RAISERROR('Version number must be smaller than 7 and greater or equal to 0!',17,1)
			RETURN
		END
	ELSE
		IF @version = @currentVersion -- check whether the version parameter is the current parameter
			BEGIN
				PRINT N'We are already on this version!'
				RETURN
			END
		ELSE
		DECLARE @currentProcedure NVARCHAR(50)
		SET @currentVersion = (SELECT currentVersion FROM CurrentVersion)  -- get the current version of the database
		IF @currentVersion < @version
			BEGIN
				WHILE @currentVersion < @version
					BEGIN
						PRINT N'We are at version ' + CAST(@currentVersion as NVARCHAR(10))

						SET @currentProcedure = (SELECT currentProcedure
												FROM VersionChanged
												WHERE versionTO = @currentVersion + 1)
						EXEC(@currentProcedure)
						SET @currentVersion = @currentVersion + 1
					END
			END
		ELSE 
		IF @currentVersion > @version
			BEGIN
				WHILE @currentVersion > @version
					BEGIN
						PRINT N'We are at version ' + CAST(@currentVersion as NVARCHAR(10))

						SET @currentProcedure = (SELECT backwardsProcedure
												FROM VersionChanged
												WHERE versionTO = @currentVersion)
						EXEC(@currentProcedure)
						SET @currentVersion = @currentVersion - 1

					END
			END
		UPDATE CurrentVersion
			SET currentVersion = @currentVersion
		PRINT N'Current version updated!'
		PRINT N'We reached the desired version: ' + CAST(@currentVersion as NVARCHAR(10))
END
exec RemoveDefaultConstraint
exec SetDatabaseVersions 2;
exec RevertV6;
Select * FROM VersionChanged
select * from SchemaVersion				/*verification*/
select * from CurrentVersion
EXEC goToVersion @version = 4;
EXEC goToVersion 3
EXEC goToVersion 6
EXEC goToVersion 5
EXEC goToVersion 2
EXEC goToVersion 1
EXEC goToVersion -1

--------------------------------------------------------------------------------------------------------------
--														A4

CREATE PROCEDURE RunTests
    @TestID INT
AS
BEGIN
    -- Declare variables
    DECLARE @TableName NVARCHAR(50)
    DECLARE @Position INT
    DECLARE @NoOfRows INT

    -- Cursor to get table details for the test
    DECLARE table_cursor CURSOR FOR
        SELECT t.Name, tt.Position, tt.NoOfRows
        FROM TestTables tt
        JOIN Tables t ON tt.TableID = t.TableID
        WHERE tt.TestID = @TestID
        ORDER BY tt.Position DESC;

    OPEN table_cursor;
    FETCH NEXT FROM table_cursor INTO @TableName, @Position, @NoOfRows;

    -- Loop through tables to delete and insert data
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Delete data from the table
        DECLARE @DeleteQuery NVARCHAR(MAX)
        SET @DeleteQuery = 'DELETE FROM ' + @TableName
        EXEC sp_executesql @DeleteQuery;

        -- Insert data into the table
        DECLARE @InsertQuery NVARCHAR(MAX)
        SET @InsertQuery = 'INSERT INTO ' + @TableName + ' SELECT TOP ' + CAST(@NoOfRows AS NVARCHAR) + ' * FROM ' + @TableName + ' ORDER BY (SELECT NULL)'
        EXEC sp_executesql @InsertQuery;

        FETCH NEXT FROM table_cursor INTO @TableName, @Position, @NoOfRows;
    END;

    CLOSE table_cursor;
    DEALLOCATE table_cursor;

    -- Evaluate views for the test
    DECLARE @ViewID INT
    DECLARE view_cursor CURSOR FOR
        SELECT v.ViewID
        FROM TestViews tv
        JOIN Views v ON tv.ViewID = v.ViewID
        WHERE tv.TestID = @TestID;

    OPEN view_cursor;
    FETCH NEXT FROM view_cursor INTO @ViewID;

    -- Loop through views to evaluate
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Run code to evaluate the view
        -- Replace this comment with code to evaluate the views

        FETCH NEXT FROM view_cursor INTO @ViewID;
    END;

    CLOSE view_cursor;
    DEALLOCATE view_cursor;
END;
CREATE PROCEDURE StoreTestRunData
    @TestRunID INT,
    @TableID INT,
    @StartTime DATETIME,
    @EndTime DATETIME
AS
BEGIN
    -- Store data into TestRunTables table
    INSERT INTO TestRunTables (TestRunID, TableID, StartAt, EndAt)
    VALUES (@TestRunID, @TableID, @StartTime, @EndTime);
END;
EXEC RunTests @TestID = 1; -- Replace 1 with the desired TestID

----------------------------------------------------------------------------------------------------------
--													A5

drop table Tc
drop table Tb
drop table Ta
SET NOCOUNT ON;

CREATE TABLE Ta(
	aid integer not null primary key,
	a2 integer unique,
	a3 integer
)



CREATE TABLE Tb(
	bid integer not null primary key,
	b2 integer
)

CREATE Table Tc(
	cid integer not null primary key,
	aid integer,
	bid integer,
	foreign key (aid) references Ta(aid) on delete cascade on update cascade,
	foreign key (bid) references Tb(bid) on delete cascade on update cascade
)

IF EXISTS (SELECT [name] FROM sys.objects 
            WHERE object_id = OBJECT_ID('RandIntBetween'))
BEGIN
   DROP FUNCTION RandIntBetween;
END
GO


-- With this function I generate a random number taken from a given interval
CREATE FUNCTION RandIntBetween(@lower INT, @upper INT, @rand FLOAT)
RETURNS INT
AS
BEGIN
  DECLARE @result INT;
  DECLARE @range INT = @upper - @lower + 1;
  SET @result = FLOOR(@rand * @range + @lower);
  RETURN @result;
END
GO

-- With this procedure I insert some random data into the table Ta
CREATE OR ALTER PROC insertDataIntoTa
@nrOfRows INT
AS
BEGIN
	DECLARE @aid INT
	DECLARE @a2 INT
	DECLARE @a3 INT
	SET @aid  = (SELECT MAX(aid) + 1 FROM Ta)
	if @aid is NULL
		SET @aid = 1
	SET @a2 = (SELECT MAX(a2) + 1 FROM Ta)
	if @a2 is NULL
		SET @a2 = 1
	WHILE @nrOfRows > 0
	BEGIN
		SET @a3 = [dbo].[RandIntBetween](1, 100, RAND())
		INSERT INTO Ta(aid, a2, a3) VALUES (@aid, @a2, @a3)
		SET @nrOfRows = @nrOfRows - 1
		SET @aid = @aid + 1
		SET @a2 = @a2 + 1
	END
END
GO

EXEC insertDataIntoTa 300
SELECT * FROM Ta
select * from Tb
EXEC sp_helpindex Ta
-- primary key constraint on aid column => clustered index automatically created on aid column
-- unique constraint on a2 column       => non-clustered index automaticall created on a2 column

-- 1. Clustered Index Scan
-- have to scan the entire table for the matching rows -> scan
-- ESC: 

SELECT a3
FROM Ta
WHERE a3 = 10

-- 2. Clustered Index Seek
-- particular range of rows from a clustered index -> seek
-- ESC:

SELECT a3
FROM Ta
WHERE aid between 1 and 100

-- 3. Non-Clustered Index Scan
-- retrives all the rows from the table -> scan
-- ESC:

SELECT a2
FROM Ta

-- 4. Non-Clustered Index Seek
-- for example when we search for particulars values of the a2 column on which we have a unique constraint => seek
-- ESC:

SELECT a2
FROM Ta
WHERE a2 >30

-- 5. Key Look-Up
-- non-clustered index seek and key look up
-- ESC: 

SELECT a2, a3
FROM Ta
WHERE a2 = 30

-- Part b
SELECT * FROM Tb WHERE b2 = 10

-- Create a nonclustered index on column b2
CREATE NONCLUSTERED INDEX idx_b2 ON Tb(b2)

-- Examine the execution plan again
SELECT * FROM Tb WHERE b2 = 10

-- Part c
CREATE VIEW v_ab AS
SELECT Ta.aid, Tb.bid
FROM Ta
JOIN Tc ON Ta.aid = Tc.aid
JOIN Tb ON Tb.bid = Tc.bid


select * from Ta