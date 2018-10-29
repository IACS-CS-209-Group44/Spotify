USE SpotifyDB
GO

DROP sequence IF EXISTS dbo.SEQ_AlbumID
CREATE sequence dbo.SEQ_AlbumID
  AS INT start WITH 1 increment BY 1 NO cycle;
  
DROP TABLE IF EXISTS dbo.Album;
CREATE TABLE dbo.Album(
AlbumID INT NOT NULL
  DEFAULT next value FOR dbo.SEQ_AlbumID,
AlbumUri CHAR(36) NOT NULL,
AlbumName VARCHAR(512) NOT NULL,
-- Primary Key and Unique constraints
CONSTRAINT PK_Album_AlbumID PRIMARY KEY (AlbumID),
CONSTRAINT UNQ_Album_AlbumUri UNIQUE(AlbumUri),
-- AlbumName should be unique, but unfortunately it's not; index it instead
INDEX IDX_Album_AlbumName (AlbumName),
);
GO
