USE SpotifyDB;
GO

DECLARE @i AS INT = 0;
DECLARE @BatchSize AS INT = 1000;
DECLARE @TrackCount INT;
DECLARE @tr1 INT;
DECLARE @tr2 INT;

SELECT
  @TrackCount = COALESCE(MAX(tr.TrackID),0)
FROM
  dbo.Track AS tr;

WHILE (@i * @BatchSize) < @TrackCount
BEGIN

SET @tr1 = (@i * @BatchSize + 1);
SET @tr2 = ((@i+1) * @BatchSize);

INSERT INTO dbo.PlaylistPairTrack
(PlaylistID_1, PlaylistID_2, TrackID)
SELECT
  te1.PlaylistID AS PlaylistID_1,
  te2.PlaylistID AS PlaylistID_2,
  te1.TrackID
FROM
    dbo.TrackEntry AS te1,
    dbo.TrackEntry AS te2
WHERE
  te1.TrackID = te2.TrackID
  AND te1.TrackID BETWEEN @tr1 AND @tr2
GROUP BY te1.PlaylistID, te2.PlaylistID, te1.TrackID;

SET @i = @i+1;

END
