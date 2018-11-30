USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.Prediction_Stack;
GO

CREATE TABLE dbo.Prediction_Stack(
PlaylistID INT NOT NULL,
Position SMALLINT NOT NULL,
TrackID INT NOT NULL,
BaselineRate FLOAT NOT NULL,
SimpleNameRate FLOAT NOT NULL,
TrackPairRate FLOAT NOT NULL,
CONSTRAINT PK_Prediction_Stack_PlaylistID_Position
  PRIMARY KEY (PlaylistID, Position),
CONSTRAINT UNQ_Prediction_Stack_PlaylistID_TrackID
  UNIQUE (PlaylistID, TrackID),
CONSTRAINT FK_Prediction_Stack_PlaylistID
  FOREIGN KEY (PlaylistID) 
  REFERENCES dbo.Playlist(PlaylistID),
CONSTRAINT FK_Prediction_Stack_TrackID
  FOREIGN KEY (TrackID)
  REFERENCES dbo.Track(TrackID),  
);  
