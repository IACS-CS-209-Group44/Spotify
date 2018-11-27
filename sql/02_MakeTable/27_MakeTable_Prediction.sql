USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.Prediction;
GO

CREATE TABLE dbo.Prediction(
PredictionStrategyID TINYINT NOT NULL,
PlaylistID INT NOT NULL,
Position SMALLINT NOT NULL,
TrackID INT NOT NULL,
-- Slots with up to 10 features used in downstream predictions
x1 FLOAT NULL,
x2 FLOAT NULL,
x3 FLOAT NULL,
x4 FLOAT NULL,
x5 FLOAT NULL,
x6 FLOAT NULL,
x7 FLOAT NULL,
x8 FLOAT NULL,
x9 FLOAT NULL,
x10 FLOAT NULL,
-- Constraints
CONSTRAINT PK_Prediction PRIMARY KEY (PredictionStrategyID, PlaylistID, Position),
CONSTRAINT UNQ_Prediction UNIQUE (PredictionStrategyID, PlaylistID, TrackID),
CONSTRAINT FK_Prediction_PredictionStrategyID
  FOREIGN KEY (PredictionStrategyID) REFERENCES dbo.PredictionStrategy(PredictionStrategyID),
CONSTRAINT FK_Prediction_PlaylistID
  FOREIGN KEY (PlaylistID) REFERENCES dbo.Playlist(PlaylistID),
CONSTRAINT FK_TrackID
  FOREIGN KEY (TrackID) REFERENCES dbo.Track(TrackID)
);
