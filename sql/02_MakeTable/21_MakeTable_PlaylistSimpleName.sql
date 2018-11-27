USE SpotifyDB;
GO

DROP TABLE IF EXISTS PlaylistSimpleName;
GO

CREATE TABLE dbo.PlaylistSimpleName(
PlaylistSimpleNameID INT NOT NULL,
PlaylistSimpleName VARCHAR(512) NOT NULL,
CONSTRAINT PK_PlaylistSimpleName_PlaylistSimpleNameID PRIMARY KEY (PlaylistSimpleNameID),
CONSTRAINT UNQ_PlaylistSimpleName_PlaylistSimpleName UNIQUE (PlaylistSimpleName),
);
GO
