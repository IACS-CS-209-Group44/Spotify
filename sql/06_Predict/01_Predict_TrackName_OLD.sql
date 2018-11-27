USE SpotifyDB;
GO

DECLARE @PlaylistCount AS INT = 1000000;
DECLARE @BatchSize AS INT = 100;
DECLARE @i AS INT = 0;
DECLARE @p1 INT;
DECLARE @p2 INT;

WHILE (@i * @BatchSize) < @PlaylistCount
BEGIN

-- Range of playlists for this loop iteration
SET @p1 = (@i * @BatchSize + 1);
SET @p2 = ((@i+1) * @BatchSize);

-- Get rid of old predictions with this prediction strategy
-- in the current playlist block.
DELETE
  pr
FROM
  dbo.Prediction AS pr
  INNER JOIN dbo.PredictionStrategy AS ps ON
    ps.PredictionStrategyID = pr.PredictionStrategyID
WHERE
  ps.PredictionStrategyName = 'PlaylistName'
  AND pr.PlaylistID BETWEEN @p1 AND @p2;

-- Insert the current block of predictions
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
-- Current block of PlaylistIDs
WHERE pl.PlaylistID BETWEEN @p1 AND @p2
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

-- Status update; manual loop increment
PRINT CONCAT('Completed PlaylistID ', @i*@BatchSize+1, ' to ', (@i+1)*@BatchSize);
SET @i = @i+1;

END
