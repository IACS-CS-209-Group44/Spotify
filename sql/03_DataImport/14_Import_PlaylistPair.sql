USE SpotifyDB;
GO

TRUNCATE TABLE dbo.PlaylistPair;
GO

INSERT INTO dbo.PlaylistPair
(PlaylistID_1, PlaylistID_2, Frequency)
SELECT
  te1.PlaylistID AS PlaylistID_1,
  te2.PlaylistID AS PlaylistID_2,
  COUNT(te1.TrackID) AS Frequency
FROM
    dbo.TrackEntry AS te1,
    dbo.TrackEntry AS te2
WHERE
  te1.TrackID = te2.TrackID
GROUP BY te1.PlaylistID, te2.PlaylistID;
