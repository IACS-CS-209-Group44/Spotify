USE SpotifyDB
GO

ALTER TABLE dbo.Track
DROP CONSTRAINT IF EXISTS FK_Track_AlbumID
GO

TRUNCATE TABLE dbo.Album;
GO

INSERT INTO dbo.Album
(AlbumName, AlbumUri)
SELECT
  pe.AlbumName,
  pe.AlbumUri
FROM
  r.PlaylistEntry AS pe
GROUP BY pe.AlbumName, pe.AlbumUri    
ORDER BY pe.AlbumUri;
GO

ALTER TABLE dbo.Track
ADD CONSTRAINT FK_Track_AlbumID
  FOREIGN KEY (AlbumID)
  REFERENCES dbo.Album(AlbumID);
GO
