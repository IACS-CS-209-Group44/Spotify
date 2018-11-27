USE SpotifyDB;
GO

INSERT INTO dbo.TrackEntry
(TrackID, PlaylistID, Position)
SELECT
  pe.TrackID,
  pe.PlaylistID,
  MIN(pe.Position) AS Position
FROM
  dbo.PlaylistEntry AS pe
GROUP BY 
  pe.TrackID, pe.PlaylistID;
