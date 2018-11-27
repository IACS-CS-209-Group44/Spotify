DECLARE @PlaylistCount AS INT = 1000000;
DECLARE @BatchSize AS INT = 1000;
DECLARE @i AS INT = 0;
DECLARE @p1 INT;
DECLARE @p2 INT;

WHILE (@i * @BatchSize) < @PlaylistCount
BEGIN

-- Range of playlists for this loop iteration
SET @p1 = (@i * @BatchSize + 1);
SET @p2 = ((@i+1) * @BatchSize);

-- Delete records in this block
DELETE pr
FROM dbo.Prediction_Baseline AS pr
WHERE pr.PlaylistID BETWEEN @p1 AND @p2;

-- CTE to get (PlaylistID, TrackID, BaselineFrequency)
WITH t1 AS (
SELECT
  pl.PlaylistID,
  pl.NumTracks,
  tr.TrackID,
  tr.Frequency AS BaselineFrequency,
  tr.TrackRank AS TrackRank
FROM
  -- Start with all playlists
  dbo.Playlist AS pl
  -- Track ranks up to 1024
  INNER JOIN dbo.TrackRank AS tr ON
    tr.TrackRank <= 1024
WHERE  
  -- Current block of PlaylistIDs
  pl.PlaylistID BETWEEN @p1 AND @p2
),
t2 AS (
SELECT
  t1.PlaylistID,
  row_number() OVER 
    (PARTITION BY t1.PlaylistID ORDER BY t1.BaselineFrequency DESC) 
    AS Position,
  t1.TrackID,
  t1.BaselineFrequency,
  t1.TrackRank
FROM
  t1
-- Don't pick tracks that are already on the first (n-10) elements of the playlist!
WHERE NOT EXISTS 
  (SELECT pe.PlaylistID FROM dbo.PlaylistEntry AS pe 
   WHERE 
    pe.PlaylistID = t1.PlaylistID AND 
    pe.TrackID = t1.TrackID AND 
    pe.Position <= t1.NumTracks - 10)
)
-- Insert the first 512 positions into the Prediction table
INSERT INTO dbo.Prediction_Baseline
(PlaylistID, Position, TrackID, BaselineFrequency, TrackRank)
SELECT
  t2.PlaylistID,
  t2.Position,
  t2.TrackID,
  t2.BaselineFrequency,
  t2.TrackRank
FROM
  t2
WHERE
  -- Only the first 512 positions
  t2.Position <= 512;

-- Status update; manual loop increment
PRINT CONCAT('Completed PlaylistID ', @i*@BatchSize+1, ' to ', (@i+1)*@BatchSize);
SET @i = @i+1;

END
