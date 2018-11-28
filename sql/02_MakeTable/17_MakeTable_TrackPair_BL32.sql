USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.TrackPair_BL32;
GO

CREATE TABLE dbo.TrackPair_BL32(
TrackID_1 INT NOT NULL,
TrackID_2 INT NOT NULL,
Frequency INT NOT NULL,
-- Primary key is the pair (TrackID_1, TrackID_2)
CONSTRAINT PK_TrackPair_BL32 PRIMARY KEY (TrackID_1, TrackID_2)
);
GO
