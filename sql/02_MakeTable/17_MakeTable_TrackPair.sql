USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.TrackPair;
GO

CREATE TABLE dbo.TrackPair(
TrackID_1 INT NOT NULL,
TrackID_2 INT NOT NULL,
Frequency INT NOT NULL,
-- Primary key is the pair (TrackID_1, TrackID_2)
CONSTRAINT PK_TrackPair_TrackID_1_TrackID_2 PRIMARY KEY (TrackID_1, TrackID_2),
-- Foreign keys onto Track table
CONSTRAINT FK_TrackMetaGenre_TrackID_1 
  FOREIGN KEY (TrackID_1) REFERENCES dbo.Track(TrackID),
CONSTRAINT FK_TrackMetaGenre_TrackID_12
  FOREIGN KEY (TrackID_2) REFERENCES dbo.Track(TrackID),
);
GO
