USE SpotifyDB
GO

DROP TABLE IF EXISTS PlaylistEntry;
GO

CREATE TABLE dbo.PlaylistEntry(
PlaylistID INT NOT NULL,
Position SMALLINT NOT NULL,
TrackID INT NOT NULL,
-- Primary key is the pair of the PlaylistID and Position
CONSTRAINT PK_PlaylistEntry PRIMARY KEY (PlaylistID, Position),
-- Foreign keys
CONSTRAINT FK_PlaylistEntry_PlaylistID
  FOREIGN KEY (PlaylistID) REFERENCES dbo.Playlist(PlaylistID),
CONSTRAINT FK_PlaylistEntry_TrackID
  FOREIGN KEY (TrackID) REFERENCES dbo.Track(TrackID),
);
