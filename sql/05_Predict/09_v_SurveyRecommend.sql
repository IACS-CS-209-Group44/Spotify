USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.SurveyRecommendations;
GO

CREATE VIEW v.SurveyRecommendations
AS

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
  pr.Position,
  pr.Frequency,
  -- The recommended track
  tr.TrackName,
  tr.TrackUri,
  row_number() OVER (ORDER BY sp.SurveyPlaylistID, pr.Position)
    AS SortOrder
FROM
  -- Start with all survey preditions
  dbo.SurveyPrediction AS pr
  -- The survey playlist
  INNER JOIN dbo.SurveyPlaylist AS sp ON
    sp.SurveyPlaylistID = pr.SurveyPlaylistID
  -- The track predicted
  INNER JOIN dbo.Track AS tr ON
    tr.TrackID = pr.TrackID
  -- The survey response
  INNER JOIN dbo.SurveyResponse AS sr ON
    sr.SurveyResponseID = sp.SurveyResponseID
WHERE 
  -- Only the next 10 tracks
  Position <= 10;
