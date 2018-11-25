USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.TrackRankBySimpleName;
GO

CREATE VIEW v.TrackRankBySimpleName AS
WITH t1 AS(
SELECT
  tfsn.SimpleName,
  row_number() OVER 
    (PARTITION BY tfsn.SimpleName ORDER BY tfsn.Frequency DESC, tr.TrackRank DESC) 
    AS TrackRank,  
  tfsn.TrackID,
  tfsn.Frequency,
  tr.Frequency AS BaselineFrequency
FROM
  dbo.TrackFreqBySimpleName AS tfsn
  INNER JOIN dbo.TrackRank AS tr ON
    tr.TrackID = tfsn.TrackID
)
SELECT
  t1.SimpleName,
  t1.TrackRank,
  t1.TrackID,
  t1.Frequency,
  t1.BaselineFrequency
FROM
  t1
WHERE
  t1.TrackRank <= 512;