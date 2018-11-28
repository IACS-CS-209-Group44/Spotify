USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.TrackPair_5;
GO

CREATE TABLE dbo.TrackPair_5(
TrackID_1 INT NOT NULL,
TrackID_2 INT NOT NULL,
Frequency INT NOT NULL,
-- Primary key is the pair (TrackID_1, TrackID_2)
CONSTRAINT PK_TrackPair_5 PRIMARY KEY (TrackID_1, TrackID_2)
);
GO
