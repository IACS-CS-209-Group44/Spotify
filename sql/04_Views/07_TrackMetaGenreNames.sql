USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.TrackMetaGenreNames;
GO

CREATE VIEW v.TrackMetaGenreNames AS
SELECT
  tr.TrackID,
  tr.TrackUri,
  mg.MetaGenreID,
  tr.TrackName,
  mg.MetaGenreName,
  af.TrackPopularityRank
FROM
  dbo.AudioFeatures AS af
  INNER JOIN dbo.Track AS tr ON
    tr.TrackID = af.TrackID
  INNER JOIN dbo.TrackMetaGenre AS tmg ON
    tmg.TrackID = tr.TrackID
  INNER JOIN dbo.MetaGenre AS mg ON
    mg.MetaGenreID = tmg.MetaGenreID;
