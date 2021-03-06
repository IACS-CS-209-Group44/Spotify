USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.PromotedArtistRate_TrackPairPromoted;
GO

CREATE VIEW v.PromotedArtistRate_TrackPairPromoted
AS

SELECT
  CAST(COUNT(par.ArtistID) AS FLOAT) / COUNT(tr.TrackID) * 100.0 AS PromotedArtistPct
FROM
  -- Start with all predictions
  v.Prediction_TrackPairPromoted AS pr
  -- The Track being predicted
  INNER JOIN dbo.Track AS tr ON
    tr.TrackID = pr.TrackID
  -- Promoted artist
  LEFT JOIN dbo.PromotedArtist AS par ON
    par.ArtistID = tr.ArtistID
WHERE
  -- Consider the top 100 predictions
  pr.Position <= 100;
  