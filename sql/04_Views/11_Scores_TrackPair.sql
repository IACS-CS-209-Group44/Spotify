USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.Scores_SimpleName;
GO

CREATE VIEW v.Scores_SimpleName AS
-- Hit rate on Training set
WITH trn AS (
SELECT
  pr.Position,
  COUNT(pr.TrackID) AS Hits,
  COUNT(pr.TrackID) / 900000.0 AS HitRate
FROM
  dbo.Prediction_SimpleName AS pr
  INNER JOIN dbo.PlaylistTrack_Last10 AS ptl ON
    ptl.PlaylistID = pr.PlaylistID AND
    ptl.TrackID = pr.TrackID
  -- Only training data
  INNER JOIN dbo.TrainTestSplit AS tts ON
    tts.PlaylistID = pr.PlaylistID AND
    tts.TrainTestTypeID = 1
WHERE
  -- Only score the top 100 guesses
  pr.Position <= 100
GROUP BY pr.Position
),
-- Hit rate on Test set
tst AS (
SELECT
  pr.Position,
  COUNT(pr.TrackID) AS Hits,
  COUNT(pr.TrackID) / 100000.0 AS HitRate
FROM
  dbo.Prediction_SimpleName AS pr
  INNER JOIN dbo.PlaylistTrack_Last10 AS ptl ON
    ptl.PlaylistID = pr.PlaylistID AND
    ptl.TrackID = pr.TrackID
  -- Only training data
  INNER JOIN dbo.TrainTestSplit AS tts ON
    tts.PlaylistID = pr.PlaylistID AND
    tts.TrainTestTypeID = 3
WHERE
  -- Only score the top 100 guesses
  pr.Position <= 100
GROUP BY pr.Position
)
SELECT
  trn.Position,
  trn.HitRate AS HitRate_Trn,
  tst.HitRate AS HitRate_Tst,
  SUM(trn.HitRate) OVER (ORDER BY trn.Position) AS CumHits_Trn,
  SUM(tst.HitRate) OVER (ORDER BY tst.Position) AS CumHits_Tst
FROM
  trn
  INNER JOIN tst ON
    tst.Position = trn.Position;
GO
