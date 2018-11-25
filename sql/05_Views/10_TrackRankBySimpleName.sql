USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.TrackRankBySimpleName;
GO

CREATE VIEW v.TrackRankBySimpleName AS
WITH t1 AS(
SELECT
  tfsn.SimpleName,
  row_number() OVER (PARTITION BY tfsn.SimpleName ORDER BY tfsn.Frequency DESC) AS TrackRank,  
  tfsn.TrackID,
  tfsn.Frequency  
FROM
  dbo.TrackFreqBySimpleName AS tfsn
)
SELECT
  t1.SimpleName,
  t1.TrackRank,
  t1.TrackID,
  t1.Frequency
FROM
  t1
WHERE
  t1.TrackRank <= 512 AND t1.Frequency > 1;