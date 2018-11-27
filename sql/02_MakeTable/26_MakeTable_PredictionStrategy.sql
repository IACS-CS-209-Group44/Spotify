USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.PredictionStrategy;
GO

CREATE TABLE dbo.PredictionStrategy(
PredictionStrategyID TINYINT NOT NULL,
PredictionStrategyName VARCHAR(64) NOT NULL,
CONSTRAINT PK_PredictionStrategy_PredictionStrategyID
  PRIMARY KEY (PredictionStrategyID),
CONSTRAINT UNQ_PredictionStrategy_PredictionStrategyName
  UNIQUE (PredictionStrategyName)
);

INSERT INTO dbo.PredictionStrategy
VALUES
(1, 'TrackFrequency'),
(2, 'PlaylistName');
--(3, 'kNN-Tracks-5'),
GO
