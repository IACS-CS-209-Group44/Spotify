USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.TrainTestType;
GO

CREATE TABLE dbo.TrainTestType(
TrainTestTypeID TINYINT NOT NULL,
TrainTestTypeCD CHAR(3) NOT NULL,
CONSTRAINT PK_TrainTestType_TrainTestTypeID PRIMARY KEY (TrainTestTypeID),
CONSTRAINT UNQ_TrainTrestTypeCD UNIQUE (TrainTestTypeCD)
);
GO

INSERT INTO dbo.TrainTestType
(TrainTestTypeID, TrainTestTypeCD)
VALUES
(1, 'TRN'),
(2, 'VAL'),
(3, 'TST');
