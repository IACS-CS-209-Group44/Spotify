USE SpotifyDB;
GO

DROP TABLE IF EXISTS TrackRank;
GO

CREATE TABLE dbo.TrackRank(
TrackID INT NOT NULL,
TrackRank INT NOT NULL,
Frequency INT NOT NULL,
CONSTRAINT PK_TrackRank_TrackID PRIMARY KEY (TrackID),
CONSTRAINT UNQ_TrackRank_TrackRank UNIQUE (TrackRank),
CONSTRAINT FK_TrackRank_TrackID
  FOREIGN KEY (TrackID) REFERENCES dbo.Track(TrackID),
);
GO

INSERT INTO dbo.TrackRank
(TrackID, TrackRank, Frequency)
SELECT
  TrackID, 
  TrackRank, 
  Frequency
FROM
  v.TrackRank;
GO

