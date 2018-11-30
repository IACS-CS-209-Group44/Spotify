USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.SurveyPrediction_TrackPair;
GO

CREATE VIEW v.SurveyPrediction_TrackPair AS
WITH t1 AS(
SELECT
  spe.SurveyPlaylistID,
  tp.TrackID_2 AS TrackID,
  SUM(tp.Frequency) AS Frequency
FROM
  -- Start with survey playlist entries
  dbo.SurveyPlaylistEntry AS spe
  -- For each track on the visible portion, find all its pairs
  INNER JOIN dbo.TrackPair AS tp ON
    tp.TrackID_1 = spe.TrackID
GROUP BY spe.SurveyPlaylistID, tp.TrackID_2
),
-- Get the track rank of each candidate
t2 AS(
SELECT
  t1.SurveyPlaylistID,
  t1.TrackID,
  row_number() OVER
    (partition BY t1.SurveyPlaylistID ORDER BY t1.Frequency DESC)
      AS TrackRank,
  t1.Frequency
FROM
  t1
), t3 AS (
-- Limit these to the 1024 most common tracks and
-- filter out tracks already there
SELECT 
  t2.SurveyPlaylistID,
  row_number() OVER
    (partition BY t2.SurveyPlaylistID ORDER BY t2.Frequency DESC, trr.Frequency DESC)
    AS Position,
  t2.TrackID,
  t2.Frequency,
  trr.Frequency AS BaselineFrequency,
  t2.TrackRank
FROM 
  t2
  -- Join TrackRank to get the baseline frequency
  INNER JOIN dbo.TrackRank AS trr ON
    trr.TrackID = t2.TrackID
WHERE
  -- Only want at most 512 tracks per playlist here
  t2.TrackRank <= 512 AND
  -- No duplicates
  NOT EXISTS (
    SELECT spe2.SurveyPlaylistID FROM dbo.SurveyPlaylistEntry AS spe2
    WHERE spe2.SurveyPlaylistID = t2.SurveyPlaylistID AND spe2.TrackID = t2.TrackID
    )
)
SELECT 
  t3.SurveyPlaylistID,
  t3.Position,
  t3.TrackID,
  t3.Frequency,
  t3.BaselineFrequency,
  t3.TrackRank
FROM 
  t3
WHERE
  t3.Position <= 256;
