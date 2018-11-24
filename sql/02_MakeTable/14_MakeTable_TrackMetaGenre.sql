USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.TrackMetaGenre;
GO

CREATE TABLE dbo.TrackMetaGenre(
TrackID INT NOT NULL,
MetaGenreID INT NOT NULL,
-- Primary key is the pair (TrackID, MetaGenreID)
CONSTRAINT PK_TrackGenre_TrackID_MetaGenreID PRIMARY KEY (TrackID, MetaGenreID),
-- Foreign key onto Track table
CONSTRAINT FK_TrackMetaGenre_TrackID 
  FOREIGN KEY (TrackID) REFERENCES dbo.Track(TrackID),
-- Foreign key onto Genre table
CONSTRAINT FK_TrackGenre_MetaGenreID 
  FOREIGN KEY (MetaGenreID) REFERENCES dbo.MetaGenre(MetaGenreID)
);
GO
