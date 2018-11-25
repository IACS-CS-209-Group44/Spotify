USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.TrackFreqBySimpleName;
GO

CREATE TABLE dbo.TrackFreqBySimpleName(
SimpleName VARCHAR(512) NOT NULL,
TrackID INT NOT NULL,
Frequency INT NOT NULL,
CONSTRAINT PK_TrackFreqBySimpleName_SimpleName_TrackID 
  PRIMARY KEY (SimpleName, TrackID),
CONSTRAINT FK_TrackFreqBySimpleName_TrackID
  FOREIGN KEY (TrackID) REFERENCES dbo.Track(TrackID),
INDEX IDX_TrackFreqBySimpleName_SimpleName_Freq (SimpleName, Frequency)  
)
GO

--  DROP TABLE IF EXISTS dbo.TrackFreqByPlaylistName;
--  GO
--
--  CREATE TABLE dbo.TrackFreqByPlaylistName(
--  PlaylistName VARCHAR(512) NOT NULL,
--  TrackID INT NOT NULL,
--  Frequency INT NOT NULL,
--  CONSTRAINT PK_TrackFreqByPlaylistName_PlaylistName_TrackID 
--    PRIMARY KEY (PlaylistName, TrackID),
--  CONSTRAINT FK_TrackFreqByPlaylistName_PlaylistName 
--    FOREIGN KEY (PlaylistName) REFERENCES dbo.PlaylistName(PlaylistName),
--  CONSTRAINT FK_TrackFreqByPlaylistName_TrackID
--    FOREIGN KEY (TrackID) REFERENCES dbo.Track(TrackID),
--  INDEX IDX_TrackFreqByPlaylistName_PlaylistName_Freq (PlaylistName, Frequency)  
--  )
--  GO
--