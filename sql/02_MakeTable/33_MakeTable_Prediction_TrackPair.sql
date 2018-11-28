USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.Prediction_TrackPair;
GO

CREATE TABLE dbo.Prediction_TrackPair(
PlaylistID INT NOT NULL,
Position SMALLINT NOT NULL,
TrackID INT NOT NULL,
Frequency INT NOT NULL,
BaselineFrequency INT NOT NULL,
TrackRank INT NOT NULL,
CONSTRAINT PK_Prediction_TrackPair_PlaylistID_Position
  PRIMARY KEY (PlaylistID, Position),
CONSTRAINT UNQ_Prediction_TrackPair_PlaylistID_TrackID
  UNIQUE (PlaylistID, TrackID),
CONSTRAINT FK_Prediction_TrackPair_PlaylistID
  FOREIGN KEY (PlaylistID) 
  REFERENCES dbo.Playlist(PlaylistID),
CONSTRAINT FK_Prediction_TrackPair_TrackID
  FOREIGN KEY (TrackID)
  REFERENCES dbo.Track(TrackID),  
);  
