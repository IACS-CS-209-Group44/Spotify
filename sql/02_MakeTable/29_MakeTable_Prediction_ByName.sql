USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.Prediction_SimpleName;
GO

CREATE TABLE dbo.Prediction_SimpleName(
PlaylistID INT NOT NULL,
Position SMALLINT NOT NULL,
TrackID INT NOT NULL,
Frequency INT NOT NULL,
BaselineFrequency INT NOT NULL,
TrackRank INT NOT NULL,
CONSTRAINT PK_Prediction_SimpleName_PlaylistID_Position
  PRIMARY KEY (PlaylistID, Position),
CONSTRAINT UNQ_Prediction_SimpleName_PlaylistID_TrackID
  UNIQUE (PlaylistID, TrackID),
CONSTRAINT FK_Prediction_SimpleName_PlaylistID
  FOREIGN KEY (PlaylistID) 
  REFERENCES dbo.Playlist(PlaylistID),
CONSTRAINT FK_Prediction_SimpleName_TrackID
  FOREIGN KEY (TrackID)
  REFERENCES dbo.Track(TrackID),  
);  
