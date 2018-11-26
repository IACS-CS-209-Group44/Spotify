USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.PlaylistPair;
GO

CREATE TABLE dbo.PlaylistPair(
PlaylistID_1 INT NOT NULL,
PlaylistID_2 INT NOT NULL,
Frequency INT NOT NULL,
-- Primary key is the pair (PlaylistID_1, PlaylistID_2)
CONSTRAINT PK_PlaylistPair_PlaylistIDs PRIMARY KEY (PlaylistID_1, PlaylistID_2),
-- Foreign keys onto Track table
CONSTRAINT FK_PlaylistPair_PlaylistID_1 
  FOREIGN KEY (PlaylistID_1) REFERENCES dbo.Playlist(PlaylistID),
CONSTRAINT FK_PlaylistPair_PlaylistID_2
  FOREIGN KEY (PlaylistID_2) REFERENCES dbo.Playlist(PlaylistID),
);
GO
