USE SpotifyDB;
GO

DROP TABLE IF EXISTS TrackFreqByPlaylistName;
GO

CREATE TABLE TrackFreqByPlaylistName(
PlaylistName VARCHAR(512) NOT NULL,
TrackID INT NOT NULL,
CONSTRAINT PK_TrackFreqByPlaylistName_PlaylistName_TrackID 
  PRIMARY KEY (PlaylistName, TrackID),
CONSTRAINT FK_TrackFreqByPlaylistName_PlaylistName 
  FOREIGN KEY (PlaylistName) REFERENCES dbo.PlaylistName(PlaylistName),
CONSTRAINT FK_TrackFreqByPlaylistName_TrackID
  FOREIGN KEY (TrackID) REFERENCES dbo.Track(TrackID)
)
GO

--INSERT INTO dbo.TrackFreqByPlaylistName
