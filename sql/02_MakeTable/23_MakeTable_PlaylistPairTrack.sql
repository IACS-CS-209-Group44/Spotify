USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.PlaylistPairTrack;
GO

CREATE TABLE dbo.PlaylistPairTrack(
PlaylistID_1 INT NOT NULL,
PlaylistID_2 INT NOT NULL,
TrackID INT NOT NULL,
-- Primary key is the trio(PlaylistID_1, PlaylistID_2, TrackID)
CONSTRAINT PK_PlaylistPairTrack_PlaylistIDs_TrackID 
  PRIMARY KEY (PlaylistID_1, PlaylistID_2, TrackID)
-- Foreign keys onto Playlist and Track table
--CONSTRAINT FK_PlaylistPairTrack_PlaylistID_1 
--  FOREIGN KEY (PlaylistID_1) REFERENCES dbo.Playlist(PlaylistID),
--CONSTRAINT FK_PlaylistPairTrack_PlaylistID_2
--  FOREIGN KEY (PlaylistID_2) REFERENCES dbo.Playlist(PlaylistID),
--CONSTRAINT FK_PlaylistPairTrack_TrackID
--  FOREIGN KEY (TrackID) REFERENCES dbo.Track(TrackID)
);
GO
