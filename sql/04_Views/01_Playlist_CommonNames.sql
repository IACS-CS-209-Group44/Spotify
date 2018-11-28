DROP VIEW IF EXISTS v.Playlist_CommonNames;
GO

CREATE VIEW v.Playlist_CommonNames AS
WITH t1 AS(
SELECT
TOP 5000
  pl.PlaylistName,
  COUNT(pl.PlaylistID) AS PlaylistNameFreq
FROM
  dbo.Playlist AS pl
  GROUP BY pl.PlaylistName
  ORDER BY COUNT(pl.PlaylistID) DESC
)
SELECT
  t1.PlaylistName,
  t1.PlaylistNameFreq,
  SUM(PlaylistNameFreq) OVER (ORDER BY PlaylistNameFreq DESC) AS CumFreq
FROM
  t1;
GO
