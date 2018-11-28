USE SpotifyDB;
GO

DROP TABLE IF EXISTS PlaylistTrack_Visible;
GO

CREATE TABLE PlaylistTrack_Visible(
PlaylistID INT NOT NULL,
TrackID INT NOT NULL,
CONSTRAINT PK_PalylistTrack_Visible
  PRIMARY KEY (PlaylistID, TrackID),
CONSTRAINT FK_PlaylistTrack_Visible_PlaylistID
  FOREIGN KEY (PlaylistID)
  REFERENCES dbo.Playlist(PlaylistID),
CONSTRAINT FK_PlaylistTrack_Visible_TrackID
  FOREIGN KEY (TrackID)
  REFERENCES dbo.Track(TrackID)
);
GO
