USE SpotifyDB;
GO

DECLARE @TrackCount AS INT;
DECLARE @BatchSize AS INT = 10000;
DECLARE @i AS INT = 0;
DECLARE @t1 INT;
DECLARE @t2 INT;

-- Get last TrackID
SELECT
  @TrackCount = COALESCE(MAX(tr.TrackID),0)
FROM
  dbo.Track AS tr;

WHILE (@i * @BatchSize) < @TrackCount
BEGIN

-- Range of playlists for this loop iteration
SET @t1 = (@i * @BatchSize + 1);
SET @t2 = ((@i+1) * @BatchSize);

WITH t1 AS (
SELECT
  tp.TrackID_1,
  tp.TrackID_2,
  tp.Frequency,
  row_number() OVER
    (partition BY tp.TrackID_1 ORDER BY Frequency DESC)
    AS ColumnRank
FROM
  dbo.TrackPair AS tp
WHERE
  -- Selected range of TrackIDs
  tp.TrackID_1 BETWEEN @t1 AND @t2 AND
  -- Only use entries with frequency > 2
  tp.Frequency > 2 AND
  -- Don't return TrackID_1 again (obviously)
  tp.TrackID_2 <> tp.TrackID_1
)
INSERT INTO dbo.TrackPair_BL64
(TrackID_1, TrackID_2, Frequency)
SELECT
  t1.TrackID_1,
  t1.TrackID_2,
  t1.Frequency
FROM
  t1
WHERE
  -- Only the top 64 tracks arising from the TrackID_1
  t1.ColumnRank <= 64;

-- Status update; manual loop increment
PRINT CONCAT('Completed TrackID ', @t1, ' to ', @t2);
SET @i = @i+1;

END
