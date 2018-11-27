USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.TrackRankBySimpleName;
GO

CREATE TABLE dbo.TrackRankBySimpleName(
PlaylistSimpleNameID INT NOT NULL,
TrackRank SMALLINT NOT NULL,
TrackID INT NOT NULL,
Frequency INT NOT NULL,
BaselineFrequency INT NOT NULL,
CONSTRAINT PK_TrackRankBySimpleName_PlaylistSimpleNameID_TrackRank
  PRIMARY KEY (PlaylistSimpleNameID, TrackRank),
CONSTRAINT UNQ_TrackRankBYSimpleName_PlaylistSimpleNameID_TrackID
  UNIQUE (PlaylistSimpleNameID, TrackID),
CONSTRAINT FK_TrackRankBySimpleName_PlaylistSimpleNameID
  FOREIGN KEY (PlaylistSimpleNameID)
  REFERENCES dbo.PlaylistSimpleName(PlaylistSimpleNameID),
CONSTRAINT FK_TrackRankBySimpleName_TrackID
  FOREIGN KEY (TrackID)
  REFERENCES dbo.Track(TrackID),
);
