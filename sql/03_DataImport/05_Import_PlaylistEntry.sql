USE SpotifyDB
GO

TRUNCATE TABLE dbo.PlaylistEntry;
GO

INSERT INTO dbo.PlaylistEntry
(PlaylistID, Position, TrackID)
SELECT
  pe.PlaylistID,
  pe.Position,
  t.TrackID
FROM
  r.PlaylistEntry AS pe
  INNER JOIN dbo.Track AS t ON
    t.TrackUri = pe.TrackUri;
GO
