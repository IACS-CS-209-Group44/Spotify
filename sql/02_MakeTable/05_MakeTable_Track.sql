USE SpotifyDB
GO

DROP sequence IF EXISTS dbo.SEQ_TrackID
CREATE sequence dbo.SEQ_TrackID
  AS INT start WITH 1 increment BY 1 NO cycle;
  
DROP TABLE IF EXISTS dbo.Track;
CREATE TABLE dbo.Track(
TrackID INT NOT NULL
  DEFAULT next value FOR dbo.SEQ_TrackID,
ArtistID INT NOT NULL,
AlbumID INT NOT NULL,
TrackUri CHAR(36) NOT NULL,
TrackName VARCHAR(512) NOT NULL,
-- Primary Key and Unique constraints
CONSTRAINT PK_Track_TrackID PRIMARY KEY (TrackID),
CONSTRAINT UNQ_Track_TrackUri UNIQUE(TrackUri),
-- TrackName should be unique, but unfortunately it's not; index it instead
INDEX IDX_Track_TrackName (TrackName),
-- Foreign keys on ArtistID and AlbumID
CONSTRAINT FK_Track_ArtistID FOREIGN KEY (ArtistID) 
  REFERENCES dbo.Artist(ArtistID),
CONSTRAINT FK_Track_AlbumID FOREIGN KEY (AlbumID) 
  REFERENCES dbo.Album(AlbumID)
);
GO
