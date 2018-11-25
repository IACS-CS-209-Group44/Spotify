USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.TrackRank;
GO

CREATE VIEW v.TrackRank
AS
WITH t1 AS (
SELECT
pe.TrackID,
COUNT(pe.TrackID) AS Frequency
FROM
  dbo.PlaylistEntry AS pe
  INNER JOIN dbo.TrainTestSplit AS tts ON
    tts.PlaylistID = pe.PlaylistID
WHERE
  --Only training data!
  tts.TrainTestTypeID = 1
GROUP BY pe.TrackID
)
SELECT
  row_number() OVER (ORDER BY t1.Frequency DESC) AS TrackRank,
  t1.TrackID,
  t1.Frequency
FROM
  t1;
GO
