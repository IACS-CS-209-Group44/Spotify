USE SpotifyDB
GO

ALTER TABLE dbo.Track
DROP CONSTRAINT IF EXISTS FK_Track_ArtistID
GO

TRUNCATE TABLE dbo.Artist;
GO

INSERT INTO dbo.Artist
(ArtistName, ArtistUri)
SELECT
  pe.ArtistName,
  pe.ArtistUri
FROM
  r.PlaylistEntry AS pe
GROUP BY 
  pe.ArtistName, pe.ArtistUri
ORDER BY pe.ArtistUri;
GO

ALTER TABLE dbo.Track
ADD CONSTRAINT FK_Track_ArtistID
  FOREIGN KEY (ArtistID)
  REFERENCES dbo.Artist(ArtistID);
GO
