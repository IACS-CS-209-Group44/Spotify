USE SpotifyDB
GO

DROP sequence IF EXISTS dbo.SEQ_ArtistID
CREATE sequence dbo.SEQ_ArtistID
  AS INT start WITH 1 increment BY 1 NO cycle;
  
DROP TABLE IF EXISTS dbo.Artist;
CREATE TABLE dbo.Artist(
ArtistID INT NOT NULL
  DEFAULT next value FOR dbo.SEQ_ArtistID,
ArtistUri CHAR(37) NOT NULL,
ArtistName VARCHAR(512) NOT NULL,
-- Primary Key and Unique constraints
CONSTRAINT PK_Artist_ArtistID PRIMARY KEY (ArtistID),
CONSTRAINT UNQ_Artist_ArtistUri UNIQUE(ArtistUri),
-- ArtistName should be unique, but unfortunately it's not; index it instead
INDEX IDX_Artist_ArtistName (ArtistName),
);
GO
