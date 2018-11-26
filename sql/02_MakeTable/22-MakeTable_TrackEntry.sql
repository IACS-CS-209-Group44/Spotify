USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.TrackEntry;
GO

CREATE TABLE dbo.TrackEntry(
TrackID INT NOT NULL,
PlaylistID INT NOT NULL,
Position SMALLINT NOT NULL,
CONSTRAINT PK_TrackEntry_TrackID_PlaylistID 
  PRIMARY KEY (TrackID, PlaylistID),
CONSTRAINT FK_TrackEntry_TrackID
  FOREIGN KEY (TrackID) REFERENCES dbo.Track(TrackID),
CONSTRAINT FK_TrackEntry_PlaylistID
  FOREIGN KEY (PlaylistID) REFERENCES dbo.Playlist(PlaylistID)
);
GO
