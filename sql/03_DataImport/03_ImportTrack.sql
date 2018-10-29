USE SpotifyDB
GO

TRUNCATE TABLE dbo.Track;
GO

INSERT INTO dbo.Track
(TrackName, TrackUri, ArtistID, AlbumID)
SELECT
  pe.TrackName,
  pe.TrackUri,
  ar.ArtistID,
  al.AlbumID
FROM
  r.PlaylistEntry AS pe
  INNER JOIN dbo.Artist AS ar ON
    ar.ArtistUri = pe.ArtistUri
  INNER JOIN dbo.Album AS al ON
    al.AlbumUri = pe.AlbumUri
GROUP BY pe.TrackName, pe.TrackUri, ar.ArtistID, al.AlbumID
ORDER BY pe.TrackUri;
GO
