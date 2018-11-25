USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.TrackRankByPlaylistName;
GO

CREATE VIEW v.TrackRankByPlaylistName AS
WITH t1 AS(
SELECT
  tfpn.PlaylistName,
  row_number() OVER (PARTITION BY tfpn.PlaylistName ORDER BY tfpn.Frequency DESC) AS TrackRank,  
  tfpn.TrackID,
  tfpn.Frequency  
FROM
  dbo.TrackFreqByPlaylistName AS tfpn
)
SELECT
  t1.PlaylistName,
  t1.TrackRank,
  t1.TrackID,
  t1.Frequency
FROM
  t1
WHERE
  t1.TrackRank <= 512 AND t1.Frequency > 1;