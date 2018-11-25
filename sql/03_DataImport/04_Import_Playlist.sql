USE SpotifyDB
GO

ALTER TABLE dbo.PlaylistEntry
DROP CONSTRAINT IF EXISTS FK_PlaylistEntry_PlaylistID;
GO

TRUNCATE TABLE dbo.Playlist;
GO

INSERT INTO dbo.Playlist
(PlaylistID, PlaylistName, NumTracks, NumArtists, NumFollowers, NumEdits,
 DurationMS, IsCollaborative, ModifiedAt)
SELECT
  pl.PlaylistID,
  pl.PlaylistName,
  pl.NumTracks,
  pl.NumArtists,
  pl.NumFollowers,
  pl.NumEdits,
  pl.DurationMS,
  pl.IsCollaborative,
  pl.ModifiedAt
FROM
  r.Playlist AS pl;
GO

ALTER TABLE dbo.PlaylistEntry
ADD CONSTRAINT FK_PlaylistEntry_PlaylistID
  FOREIGN KEY (PlaylistID) REFERENCES dbo.Playlist(PlaylistID),
GO
