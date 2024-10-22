-- Encription the Password column in the Investor table
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'Str0ngP@ssw0rd!';

-- make sure the Master Key exists
SELECT name KeyName,
symmetric_key_id KeyID,
key_length KeyLength,
algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
go

CREATE CERTIFICATE IVTPass
WITH SUBJECT = 'Investor Sample Password';
GO

CREATE SYMMETRIC KEY IVTPass_SM
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE IVTPass;
GO
OPEN SYMMETRIC KEY IVTPass_SM
DECRYPTION BY CERTIFICATE IVTPass;
UPDATE dbo.Investor set [Password] = EncryptByKey(Key_GUID('IVTPass_SM'), convert(varbinary,[Password]) )
GO

OPEN SYMMETRIC KEY IVTPass_SM
DECRYPTION BY CERTIFICATE IVTPass;
SELECT *,
CONVERT(varchar, DecryptByKey([Password]))
AS 'Decrypted password'
FROM dbo.Investor;
