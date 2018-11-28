DROP VIEW IF EXISTS v.Playlist_StandardizedFrequency;
GO

CREATE VIEW v.Playlist_StandardizedFrequency AS
WITH t1 AS(
SELECT
  psmp.StandardizedName,
  COUNT(pl.PlaylistID) AS Frequency
FROM
  dbo.PlaylistStandardizedNameMap AS psmp
  INNER JOIN dbo.Playlist AS pl ON
    pl.PlaylistName = psmp.PlaylistName
GROUP BY psmp.StandardizedName
)
SELECT
  row_number() OVER (ORDER BY t1.Frequency DESC) AS Rank,
  t1.StandardizedName,
  t1.Frequency,
  SUM(t1.Frequency) OVER (ORDER BY t1.Frequency DESC) AS CumFreq
FROM
  t1
GO
