USE SpotifyDB;
GO

DROP TABLE IF EXISTS PlaylistName;
GO

CREATE TABLE dbo.PlaylistName(
PlaylistNameID INT NOT NULL,
PlaylistName VARCHAR(512) NOT NULL,
PlaylistSimpleNameID INT NULL,
PlaylistSimpleName VARCHAR(512) NOT NULL,
CONSTRAINT PK_PlaylistName_PlaylistName PRIMARY KEY (PlaylistName),
CONSTRAINT UNQ_PlaylistName_PlaylistNameID UNIQUE (PlaylistNameID),
INDEX IDX_PlaylistName_PlaylistSimpleName (PlaylistSimpleName),
);
GO
