-- Get rid of old predictions with this prediction strategy
DELETE
  pr
FROM
  dbo.Prediction AS pr
  INNER JOIN dbo.PredictionStrategy AS ps ON
    ps.PredictionStrategyID = pr.PredictionStrategyID
WHERE
  ps.PredictionStrategyName = 'PlaylistName';
GO

WITH t1 AS(
SELECT
  pl.PlaylistID,
  row_number() OVER (partition BY pl.PlaylistID ORDER BY tfsn.Frequency DESC, trr.TrackRank DESC)
    AS Position,    
  tfsn.TrackID,
  trr.Frequency AS BaselineFrequency,
  tfsn.Frequency AS FrequencyByName
FROM
  --Start with playlists
  dbo.Playlist AS pl
  --Get the simple name
  INNER JOIN dbo.PlaylistName AS pn ON
    pn.PlaylistName = pl.PlaylistName
  -- Most common tracks with this name
  INNER JOIN dbo.TrackFreqBySimpleName AS tfsn ON
    tfsn.SimpleName = pn.SimpleName
  -- The baseline popularity of this track
  INNER JOIN dbo.TrackRank AS trr ON
    trr.TrackID = tfsn.TrackID
)
INSERT INTO dbo.Prediction
(PredictionStrategyID, PlaylistID, Position, TrackID, x1, x2)
SELECT
  ps.PredictionStrategyID,
  t1.PlaylistID,
  t1.Position,
  t1.TrackID,
  t1.BaselineFrequency AS x1,
  t1.FrequencyByName AS x2
FROM
  t1
  -- We are predicting with the PlaylistName strategy
  INNER JOIN dbo.PredictionStrategy AS ps ON
    ps.PredictionStrategyName = 'PlaylistName'
WHERE
  -- Only the top 100 predictions
  t1.Position <= 100;
