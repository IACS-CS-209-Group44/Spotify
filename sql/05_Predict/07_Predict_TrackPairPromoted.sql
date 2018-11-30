USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.Prediction_TrackPairPromoted;
GO

CREATE VIEW v.Prediction_TrackPairPromoted
AS
WITH t1 AS (
SELECT
  pr.PlaylistID,
  pr.TrackID,
  pr.Frequency * COALESCE(par.PromotionFactor, 1.0) AS Frequency,
  pr.BaselineFrequency * COALESCE(par.PromotionFactor, 1.0) AS BaselineFrequency
FROM
  -- Start with regular predictions in this model
  dbo.Prediction_TrackPair AS pr
  -- The Track
  INNER JOIN dbo.Track AS tr ON 
    tr.TrackID = pr.TrackID
  -- Join PromotedArtist if applicable
  LEFT JOIN dbo.PromotedArtist AS par ON
    par.ArtistID = tr.ArtistID
)
SELECT
  t1.PlaylistID,
  row_number() OVER 
    (partition BY t1.PlaylistID
     ORDER BY t1.Frequency DESC, t1.BaselineFrequency desc)
     AS Position,
  t1.TrackID,
  t1.Frequency,
  t1.BaselineFrequency
FROM
  t1;
