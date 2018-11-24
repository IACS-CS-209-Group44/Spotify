USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.TrackGenreNames;
GO

CREATE VIEW v.TrackGenreNames AS
SELECT
  tr.TrackID,
  tr.TrackUri,
  g.GenreID,
  tr.TrackName,
  g.GenreName,
  af.TrackPopularityRank
FROM
  dbo.AudioFeatures AS af
  INNER JOIN dbo.Track AS tr ON
    tr.TrackID = af.TrackID
  INNER JOIN dbo.TrackGenre AS tg ON
    tg.TrackID = tr.TrackID
  INNER JOIN dbo.Genre AS g ON
    g.GenreID = tg.GenreID;
