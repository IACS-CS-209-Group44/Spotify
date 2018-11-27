-- For simple playlist names with fewer than 1024 tracks,
-- pad out the entries using the most common overall tracks
-- These new entries will have a frequency of 0 within the name.

-- t1 is a collection of PlaylistSimpleName entries with < 1024 tracks
WITH t1 AS(
SELECT
  trsn.PlaylistSimpleNameID,
  COUNT(trsn.TrackID) AS Tracks
FROM
  dbo.TrackRankBySimpleName AS trsn
GROUP BY trsn.PlaylistSimpleNameID
HAVING COUNT(trsn.TrackID) < 1024
),

-- Join the top 1024 overall tracks; these are the candidate supplemental entries
t2 AS(
SELECT
  t1.PlaylistSimpleNameID,
  t1.Tracks,
  trr.TrackRank AS BaselineTrackRank,
  trr.Frequency AS BaselineFrequency,
  trr.TrackID
FROM
  t1
  INNER JOIN dbo.TrackRank AS trr ON
    trr.TrackRank <= 1024
),

-- Select only those candidate tracks that do not duplicate tracks already preseent
t3 AS(
SELECT
  t2.PlaylistSimpleNameID,
  row_number() OVER 
    (partition BY PlaylistSimpleNameID ORDER BY BaselineTrackRank) 
    + t2.Tracks
    AS TrackRank,
  t2.TrackID,
  t2.Tracks,  
  t2.BaselineTrackRank,
  t2.BaselineFrequency
FROM
  t2
WHERE
  --Only tracks not already present
  NOT EXISTS (
  SELECT trsn2.PlaylistSimpleNameID
  FROM  
    dbo.TrackRankBySimpleName AS trsn2
  WHERE 
    trsn2.PlaylistSimpleNameID = t2.PlaylistSimpleNameID AND
    trsn2.TrackID = t2.TrackID
  )
)
-- Insert the supplemental records up to TrackRank 1024
INSERT INTO dbo.TrackRankBySimpleName
(PlaylistSimpleNameID, TrackRank, TrackID, Frequency, BaselineFrequency)
SELECT
  t3.PlaylistSimpleNameID,
  t3.TrackRank,
  t3.TrackID,
  0 AS Frequency,
  t3.BaselineFrequency
FROM
  t3
WHERE
  t3.TrackRank <= 1024
ORDER BY PlaylistSimpleNameID, TrackRank;