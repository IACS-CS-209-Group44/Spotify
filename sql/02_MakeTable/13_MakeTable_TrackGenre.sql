USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.TrackGenre;
GO

CREATE TABLE dbo.TrackGenre(
TrackID INT NOT NULL,
GenreID INT NOT NULL,
-- Primary key is the pair (TrackID, GenreID)
CONSTRAINT PK_TrackGenre_TrackID_GenreID PRIMARY KEY (TrackID, GenreID),
-- Foreign key onto Track table
CONSTRAINT FK_TrackGenre_TrackID 
  FOREIGN KEY (TrackID) REFERENCES dbo.Track(TrackID),
-- Foreign key onto Genre table
CONSTRAINT FK_TrackGenre_GenreID 
  FOREIGN KEY (GenreID) REFERENCES dbo.Genre(GenreID)
);
GO
