DROP VIEW IF EXISTS v.TopTracks_Uri;
GO

CREATE VIEW v.TopTracks_Uri AS
SELECT
  tt.Rank,
  tt.TrackUri
FROM
  v.TopTracks AS tt;
