USE SpotifyDB
GO

DROP TABLE IF EXISTS dbo.Counter;
GO

CREATE TABLE dbo.Counter(
i SMALLINT NOT NULL,
CONSTRAINT PK_Counter_i PRIMARY KEY (i)
);

-- Populate Counter with slots up to 512
INSERT INTO dbo.Counter (i)
VALUES (1), (2), (3), (4), (5), (6), (7), (8);
-- Double size of the table until it has 512 elements
INSERT INTO dbo.Counter (i) SELECT i + 8 AS i FROM dbo.Counter;
INSERT INTO dbo.Counter (i) SELECT i + 16 AS i FROM dbo.Counter;
INSERT INTO dbo.Counter (i) SELECT i + 32 AS i FROM dbo.Counter;
INSERT INTO dbo.Counter (i) SELECT i + 64 AS i FROM dbo.Counter;
INSERT INTO dbo.Counter (i) SELECT i + 128 AS i FROM dbo.Counter;
INSERT INTO dbo.Counter (i) SELECT i + 256 AS i FROM dbo.Counter;
GO
