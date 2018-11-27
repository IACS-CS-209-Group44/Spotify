TRUNCATE TABLE dbo.TrackRankBySimpleName;
GO

-- CTE with the core group by query computing frequency of each 
-- (PlaylistSimpleNameID, TrackID) pair
WITH t1 AS (
SELECT
  pn.PlaylistSimpleNameID,
  pe.TrackID,
  COUNT(pe.TrackID) AS Frequency
FROM
  -- Start with all playlist entries
  dbo.PlaylistEntry AS pe
  -- The playlist for this entry
  INNER JOIN dbo.Playlist AS pl ON
    pl.PlaylistID = pe.PlaylistID
  -- Figure out if this playlist is train or test
  INNER JOIN dbo.TrainTestSplit AS tts ON
    tts.PlaylistID = pe.PlaylistID
  -- Get the PlaylistSimpleNameID from PlaylistName
  INNER JOIN dbo.PlaylistName AS pn ON
    pn.PlaylistName = pl.PlaylistName
WHERE
  -- Only training data!
  tts.TrainTestTypeID = 1
GROUP BY pn.PlaylistSimpleNameID, pe.TrackID
),
-- Join t1 against TrackRank to get BaselineFrequency and 
-- compute the rank of each track sharing the SimpleName
t2 AS(
SELECT
  t1.PlaylistSimpleNameID,
  row_number() OVER 
    (partition BY t1.PlaylistSimpleNameID
     ORDER BY t1.Frequency DESC, tr.Frequency DESC)
     AS TrackRank,
  t1.TrackID,
  t1.Frequency,
  tr.Frequency AS BaselineFrequency
FROM
  t1
  INNER JOIN dbo.TrackRank AS tr ON
    tr.TrackID = t1.TrackID
)
-- Insert into TrackRankBySimpleName from t2
INSERT INTO dbo.TrackRankBySimpleName
(PlaylistSimpleNameID, TrackRank, TrackID, Frequency, BaselineFrequency)
SELECT
  t2.PlaylistSimpleNameID,
  t2.TrackRank,
  t2.TrackID,
  t2.Frequency,
  t2.BaselineFrequency
FROM
  t2
WHERE
  -- Only compute ranks up to 1024 (need < 512 for prediction)
  t2.TrackRank <= 1024;
