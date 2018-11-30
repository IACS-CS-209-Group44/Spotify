USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.PromotedArtist;
GO

CREATE TABLE dbo.PromotedArtist(
ArtistID INT NOT NULL,
ArtistUri CHAR(37) NOT NULL,
PromotionFactor FLOAT NOT NULL,
CONSTRAINT PK_PromotedArtist_ArtistID PRIMARY KEY (ArtistID),
CONSTRAINT UNQ_PromotedArtist_ArtistUri UNIQUE (ArtistUri),
CONSTRAINT FK_PromotedArtist_ArtistID
  FOREIGN KEY (ArtistID) REFERENCES dbo.Artist(ArtistID),
CONSTRAINT FK_PromotedArtist_ArtistUri
  FOREIGN KEY (ArtistUri) REFERENCES dbo.Artist(ArtistUri)
);
GO

INSERT INTO dbo.PromotedArtist
SELECT
  a.ArtistID,
  a.ArtistUri,
  2.0 AS PromotionFactor
FROM
  r.PromotedArtist AS pa
  INNER JOIN dbo.Artist AS a ON
    a.ArtistUri = pa.artist_uri;
GO
