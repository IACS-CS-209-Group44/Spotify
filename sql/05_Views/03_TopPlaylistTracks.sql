DROP VIEW IF EXISTS v.TopPlaylistTracks;
GO

CREATE VIEW v.TopPlaylistTracks AS
WITH t1 AS (
SELECT
  psf.Rank,
  psf.StandardizedName,
  t.TrackID,
  COUNT(t.TrackID) AS TrackFrequency  
FROM
  v.Playlist_StandardizedFrequency AS psf
  INNER JOIN dbo.PlaylistStandardizedNameMap AS psnm ON
    psnm.StandardizedName = psf.StandardizedName
  INNER JOIN dbo.Playlist AS pl ON
    pl.PlaylistName = psnm.PlaylistName
  INNER JOIN dbo.PlaylistEntry AS pe ON
    pe.PlaylistID = pl.PlaylistID
  INNER JOIN dbo.Track AS t ON
    t.TrackID = pe.TrackID
GROUP BY psf.Rank, psf.StandardizedName, t.TrackID
),
t2 AS (
SELECT
  t1.Rank AS PlaylistRank,
  t1.TrackFrequency,
  row_number() OVER (partition BY t1.Rank ORDER BY t1.TrackFrequency DESC)
    AS TrackRank,
  t1.StandardizedName AS PlaylistName,
  t.TrackName,
  t.TrackUri
FROM
  t1
  INNER JOIN dbo.Track AS t ON t.TrackID = t1.TrackID
)
SELECT
  t2.PlaylistRank,
  t2.TrackRank,
  t2.PlaylistName,
  t2.TrackName,
  t2.TrackUri,
  t2.TrackFrequency
FROM t2
WHERE t2.TrackRank <= 100;
GO
