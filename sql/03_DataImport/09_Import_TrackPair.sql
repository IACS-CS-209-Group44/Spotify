USE SpotifyDB;
GO

TRUNCATE TABLE dbo.TrackPair;
GO

INSERT INTO dbo.TrackPair
(TrackID_1, TrackID_2)
SELECT
  pe1.TrackID AS TrackID_1,
  pe2.TrackID AS TrackID_2,
  COUNT(pl.PlaylistID) AS Frequency
FROM
  -- Start with playlists
  dbo.Playlist AS pl
  -- Train, Val or Test?
  INNER JOIN dbo.TrainTestSplit AS tts ON
    tts.PlaylistID = pl.PlaylistID
  -- Get two copies of all the tracks on this playlist
  INNER JOIN dbo.PlaylistEntry AS pe1 ON
    pe1.PlaylistID = pl.PlaylistID
  INNER JOIN dbo.PlaylistEntry AS pe2 ON
    pe2.PlaylistID = pl.PlaylistID
WHERE
  -- Only the training set!
  tts.TrainTestTypeID = 1 AND
  -- Get pairs only in the order where TrackID_1 < TrackID_2
  pe1.TrackID < pe2.TrackID  
GROUP BY
  pe1.TrackID, pe2.TrackID
GO
