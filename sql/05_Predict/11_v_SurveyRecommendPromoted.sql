USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.SurveyRecommendationsPromoted;
GO

CREATE VIEW v.SurveyRecommendationsPromoted
AS

WITH t1 AS (
SELECT
  -- Integer IDs
  sp.SurveyPlaylistID,
  tr.TrackID,
  -- Description of the Playlist
  sr.RecipientName,
  sr.RecipientEmail,
  sp.PlaylistName,
  sp.PlaylistNum,
  -- Recommendations
  row_number() OVER
    (partition BY sp.SurveyPlaylistID
     ORDER BY pr.Frequency * COALESCE(par.PromotionFactor, 1.0) DESC)
     AS Position,
  pr.Frequency * COALESCE(par.PromotionFactor, 1.0) AS AdjustedFrequency,
  -- The recommended track
  tr.TrackName,
  tr.TrackUri
FROM
  -- Start with all survey preditions
  dbo.SurveyPrediction AS pr
  -- The survey playlist
  INNER JOIN dbo.SurveyPlaylist AS sp ON
    sp.SurveyPlaylistID = pr.SurveyPlaylistID
  -- The track predicted
  INNER JOIN dbo.Track AS tr ON
    tr.TrackID = pr.TrackID
  -- The PromotedArtist on this track if applicable
  LEFT JOIN dbo.PromotedArtist AS par ON
    par.ArtistID = tr.ArtistID
  -- The survey response
  INNER JOIN dbo.SurveyResponse AS sr ON
    sr.SurveyResponseID = sp.SurveyResponseID
)
SELECT
  t1.SurveyPlaylistID,
  t1.TrackID,
  t1.RecipientName,
  t1.RecipientEmail,
  t1.PlaylistName,
  t1.PlaylistNum,
  t1.Position,
  t1.AdjustedFrequency,
  t1.TrackName,
  t1.TrackUri,
  row_number() OVER (ORDER BY t1.SurveyPlaylistID, t1.Position)
    AS SortOrder
FROM
  t1
WHERE
  t1.Position <= 10;
