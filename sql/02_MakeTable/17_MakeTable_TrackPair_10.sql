USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.TrackPair_10;
GO

CREATE TABLE dbo.TrackPair_10(
TrackID_1 INT NOT NULL,
TrackID_2 INT NOT NULL,
Frequency INT NOT NULL,
-- Primary key is the pair (TrackID_1, TrackID_2)
CONSTRAINT PK_TrackPair_10 PRIMARY KEY (TrackID_1, TrackID_2)
);
GO
