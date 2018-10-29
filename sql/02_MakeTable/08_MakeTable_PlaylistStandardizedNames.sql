DROP TABLE IF EXISTS dbo.PlaylistStandardizedNameMap;
GO

CREATE TABLE dbo.PlaylistStandardizedNameMap(
PlaylistStandardizedNameMapID SMALLINT NOT NULL,
PlaylistName VARCHAR(512) NOT NULL,
StandardizedName VARCHAR(512) NOT NULL,
Frequency INT NOT NULL,
-- Primary key & unique constraint
CONSTRAINT PK_PlaylistStandardizedName_PlaylistStandardizedNameID
  PRIMARY KEY (PlaylistStandardizedNameMapID),
CONSTRAINT UNQ_PlaylistStandardizedName_PlaylistName
  UNIQUE (PlaylistName)
);
GO
