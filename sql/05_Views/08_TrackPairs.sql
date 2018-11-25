USE SpotifyDB;
GO

DROP VIEW IF EXISTS v.TrackPairs;
GO

CREATE VIEW v.TrackPairs
AS
SELECT
  tp.TrackID_1,
  tp.TrackID_2,
  tp.Frequency
FROM
  dbo.TrackPair AS tp
WHERE
  tp.TrackID_1 < tp.TrackID_2 and
  tp.Frequency > 2;
