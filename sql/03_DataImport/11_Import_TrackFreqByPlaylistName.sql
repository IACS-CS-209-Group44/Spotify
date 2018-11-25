USE SpotifyDB;
GO

INSERT INTO dbo.TrackFreqBySimpleName
(SimpleName, TrackID, Frequency)
SELECT
  pn.SimpleName,
  pe.TrackID,
  COUNT(pe.TrackID) AS Frequency
FROM
  dbo.PlaylistEntry AS pe
  INNER JOIN dbo.Playlist AS pl ON
    pl.PlaylistID = pe.PlaylistID
  INNER JOIN dbo.TrainTestSplit AS tts 
    ON tts.PlaylistID = pe.PlaylistID
  INNER JOIN dbo.PlaylistName AS pn ON
    pn.PlaylistName = pl.PlaylistName
WHERE
  --Only training data!
  tts.TrainTestTypeID = 1
GROUP BY pn.SimpleName, pe.TrackID;
GO

--  INSERT INTO dbo.TrackFreqByPlaylistName
--  (PlaylistName, TrackID, Frequency)
--  SELECT
--    pn.PlaylistName,
--    tfsn.TrackID,
--    tfsn.Frequency
--  FROM
--    dbo.TrackFreqBySimpleName AS tfsn
--    INNER JOIN dbo.PlaylistName AS pn ON
--      pn.SimpleName = tfsn.SimpleName;
--  GO;
--