USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.Prediction_Baseline;
GO

CREATE TABLE dbo.Prediction_Baseline(
PlaylistID INT NOT NULL,
Position SMALLINT NOT NULL,
TrackID INT NOT NULL,
BaselineFrequency INT NOT NULL,
TrackRank INT NOT NULL,
CONSTRAINT PK_Prediction_Baseline_PlaylistID_Position
  PRIMARY KEY (PlaylistID, Position),
CONSTRAINT UNQ_Prediction_Baseline_PlaylistID_TrackID
  UNIQUE (PlaylistID, TrackID),
CONSTRAINT FK_Prediction_Baseline_PlaylistID
  FOREIGN KEY (PlaylistID) 
  REFERENCES dbo.Playlist(PlaylistID),
CONSTRAINT FK_Prediction_Baseline_TrackID
  FOREIGN KEY (TrackID)
  REFERENCES dbo.Track(TrackID),  
);  
