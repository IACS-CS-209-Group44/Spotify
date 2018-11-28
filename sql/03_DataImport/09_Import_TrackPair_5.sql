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

INSERT INTO dbo.TrackPair_5
(TrackID_1, TrackID_2, Frequency)
SELECT
  tp.TrackID_1,
  tp.TrackID_2,
  tp.Frequency
FROM
  dbo.TrackPair AS tp
WHERE
  tp.TrackID_1 BETWEEN @t1 AND @t2 AND
  tp.Frequency >= 5;

-- Status update; manual loop increment
PRINT CONCAT('Completed TrackID ', @t1, ' to ', @t2);
SET @i = @i+1;

END
