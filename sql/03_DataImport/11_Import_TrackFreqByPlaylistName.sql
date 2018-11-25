WITH t1 AS (
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
GROUP BY pn.SimpleName, pe.TrackID
)
SELECT
TOP 100
  pn.PlaylistName,
  t1.TrackID,
  t1.Frequency
FROM
  dbo.PlaylistName AS pn
  INNER JOIN t1 ON
    t1.SimpleName = pn.SimpleName;