USE SpotifyDB;
GO

DROP TABLE IF EXISTS PlaylistTrack_Last10;
GO

CREATE TABLE PlaylistTrack_Last10(
PlaylistID INT NOT NULL,
TrackID INT NOT NULL,
CONSTRAINT PK_PalylistTrack_Last10
  PRIMARY KEY (PlaylistID, TrackID),
CONSTRAINT FK_PlaylistTrack_Last10_PlaylistID
  FOREIGN KEY (PlaylistID)
  REFERENCES dbo.Playlist(PlaylistID),
CONSTRAINT FK_PlaylistTrack_Last10_TrackID
  FOREIGN KEY (TrackID)
  REFERENCES dbo.Track(TrackID)
);
GO
