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

INSERT INTO dbo.PlaylistTrack_Last10
(PlaylistID, TrackID)
SELECT DISTINCT
  pe.PlaylistID,
  pe.TrackID
FROM
  dbo.Playlist AS pl  
  INNER JOIN  dbo.PlaylistEntry AS pe ON
    pl.PlaylistID = pe.PlaylistID AND
    pe.Position > pl.NumTracks - 11
WHERE
  pl.PlaylistID BETWEEN @p1 AND @p2

-- Status update; manual loop increment
PRINT CONCAT('Completed PlaylistID ', @i*@BatchSize+1, ' to ', (@i+1)*@BatchSize);
SET @i = @i+1;

END
