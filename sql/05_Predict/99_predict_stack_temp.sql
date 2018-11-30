-- ****************************************************************
-- Baseline Frequency
WITH p1_f AS(
SELECT
  pr.PlaylistID,
  pr.TrackID,
  pr.BaselineFrequency
FROM
  dbo.Prediction_Baseline AS pr
WHERE
  pr.PlaylistID = 1
), 
-- Baseline normalization
p1_n AS (
SELECT
  p1_f.PlaylistID,
  CAST(SUM(p1_f.BaselineFrequency) AS FLOAT) AS BaselineTotal
FROM
  p1_f
GROUP BY p1_f.PlaylistID
),
-- Baseline rate
p1 AS(
SELECT
  p1_f.PlaylistID,
  p1_f.TrackID,
  p1_f.BaselineFrequency / p1_n.BaselineTotal AS BaselineRate
FROM
  p1_f
  INNER JOIN p1_n ON p1_n.PlaylistID = p1_f.PlaylistID
),
-- ****************************************************************
-- Frequency by Simple Name
p2_f AS(
SELECT
  pr.PlaylistID,
  pr.TrackID,
  pr.Frequency AS NameFrequency
FROM
  dbo.Prediction_SimpleName AS pr
WHERE
  pr.PlaylistID = 1
),
-- Simple Name normalization
p2_n AS (
SELECT
  p2_f.PlaylistID,
  CAST(SUM(p2_f.NameFrequency) AS FLOAT) AS NameTotal
FROM
  p2_f
GROUP BY p2_f.PlaylistID
),
-- Rate by Simple Name
p2 AS(
SELECT
  p2_f.PlaylistID,
  p2_f.TrackID,
  p2_f.NameFrequency / p2_n.NameTotal AS NameRate
FROM
  p2_f
  INNER JOIN p2_n ON p2_n.PlaylistID = p2_f.PlaylistID
),
-- ****************************************************************
-- Frequency by Track Pair
p3_f AS(
SELECT
  pr.PlaylistID,
  pr.TrackID,
  pr.Frequency AS TrackPairFrequency
FROM
  dbo.Prediction_TrackPair AS pr
WHERE
  pr.PlaylistID = 1
),
-- Simple Name normalization
p3_n AS (
SELECT
  p3_f.PlaylistID,
  CAST(SUM(p3_f.TrackPairFrequency) AS FLOAT) AS TrackPairTotal
FROM
  p3_f
GROUP BY p3_f.PlaylistID
),
-- Rate by Track Pair
p3 AS(
SELECT
  p3_f.PlaylistID,
  p3_f.TrackID,
  p3_f.TrackPairFrequency / p3_n.TrackPairTotal AS TrackPairRate
FROM
  p3_f
  INNER JOIN p3_n ON p3_n.PlaylistID = p3_f.PlaylistID
),
-- ****************************************************************
-- Merged list of candidate tracks
cand AS (
SELECT
  p1.PlaylistID,
  p1.TrackID
FROM
  p1
UNION SELECT
  p2.PlaylistID,
  p2.TrackID
FROM
  p2
),
-- Component predictions on merged tracks
ps AS(
SELECT
  cand.PlaylistID,
  cand.TrackID,
  COALESCE(p1.BaselineRate, 0.0) AS BaselineRate,
  COALESCE(p2.NameRate, 0.0) AS NameRate,
  COALESCE(p3.TrackPairRate, 0.0) AS TrackPairRate
FROM
  -- Start with all the combined candidates
  cand
  -- The Baseline rate
  LEFT JOIN p1 ON 
    p1.PlaylistID = cand.PlaylistID AND
    p1.TrackID = cand.TrackID
  -- The Simple Name rate
  LEFT JOIN p2 ON
    p2.PlaylistID = cand.PlaylistID AND
    p2.TrackID = cand.TrackID
  -- The Track Pair rate
  LEFT JOIN p3 ON
    p3.PlaylistID = cand.PlaylistID AND
    p3.TrackID = cand.TrackID
),
-- Stacked (composite) rate
comp AS (
SELECT
  ps.PlaylistID,
  ps.TrackID,
  (0.01 * ps.BaselineRate + 0.25 * ps.NameRate + 0.75 * ps.TrackPairRate) / 1.01
    AS StackedRate
FROM 
  ps
), 
-- Stacked predictions
pred AS(
SELECT
  ps.PlaylistID,
  row_number() OVER 
    (partition BY ps.PlaylistID ORDER BY StackedRate DESC)
    AS Position,
  ps.TrackID,
  comp.StackedRate,
  ps.BaselineRate,
  ps.NameRate,
  ps.TrackPairRate  
FROM
  ps
  INNER JOIN comp ON
    comp.PlaylistID = ps.PlaylistID AND
    comp.TrackID = ps.TrackID
)
-- output
SELECT
  pred.PlaylistID,
  pred.Position,
  pred.TrackID,
  pred.StackedRate,
  pred.BaselineRate,
  pred.NameRate,
  pred.TrackPairRate
FROM
  pred
WHERE
  pred.Position <= 256;