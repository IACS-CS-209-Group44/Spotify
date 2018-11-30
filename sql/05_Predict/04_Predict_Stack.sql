USE SpotifyDB;
GO

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
FROM dbo.Prediction_Stack AS pr
WHERE pr.PlaylistID BETWEEN @p1 AND @p2;

WITH t1 AS(
SELECT
  ptv.PlaylistID,
  tp.TrackID_2 AS TrackID,
  SUM(tp.Frequency) AS Frequency
FROM
  -- Start with visible playlist entries
  dbo.PlaylistTrack_Visible AS ptv
  -- For each track on the visible portion, find all its pairs
  -- Use the bandwidth limited version (top 64 columns per row)
  -- to speed performance
  INNER JOIN dbo.TrackPair_BL64 AS tp ON
    tp.TrackID_1 = ptv.TrackID
WHERE
  ptv.PlaylistID BETWEEN @p1 AND @p2
GROUP BY ptv.PlaylistID, tp.TrackID_2  
),
-- Get the track rank of each candidate
t2 AS(
SELECT
  t1.PlaylistID,
  t1.TrackID,
  row_number() OVER
    (partition BY t1.PlaylistID ORDER BY t1.Frequency DESC)
      AS TrackRank,
  t1.Frequency
FROM
  t1
), t3 AS (
-- Limit these to the 1024 most common tracks and
-- filter out tracks already there
SELECT 
  t2.PlaylistID,
  row_number() OVER
    (partition BY t2.PlaylistID ORDER BY t2.Frequency DESC, trr.Frequency DESC)
    AS Position,
  t2.TrackID,
  t2.Frequency,
  trr.Frequency AS BaselineFrequency,
  t2.TrackRank
FROM 
  t2
  -- Join Playlist to get the number of tracks
  INNER JOIN dbo.Playlist AS pl ON
    pl.PlaylistID = t2.PlaylistID
  -- Join TrackRank to get the baseline frequency
  INNER JOIN dbo.TrackRank AS trr ON
    trr.TrackID = t2.TrackID
WHERE
  -- Only want at most 512 tracks per playlist here
  t2.TrackRank <= 512 AND
  -- No duplicates
  NOT EXISTS (
    SELECT ptv2.PlaylistID FROM dbo.PlaylistTrack_Visible AS ptv2
    WHERE ptv2.PlaylistID = t2.PlaylistID AND ptv2.TrackID = t2.TrackID
    )
)
INSERT INTO dbo.Prediction_Stack
(PlaylistID, Position, TrackID, Frequency, BaselineFrequency, TrackRank)
SELECT
  t3.PlaylistID,
  t3.Position,
  t3.TrackID,
  t3.Frequency,
  t3.BaselineFrequency,
  t3.TrackRank
FROM t3
WHERE
  t3.Position <= 256;

-- Status update; manual loop increment
PRINT CONCAT('Completed PlaylistID ', @p1, ' to ', @p2);
SET @i = @i+1;

END
