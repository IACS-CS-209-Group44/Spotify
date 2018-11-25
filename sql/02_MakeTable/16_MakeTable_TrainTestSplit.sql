DROP TABLE IF EXISTS r.Playlist_trn;
DROP TABLE IF EXISTS r.Playlist_tst;
GO

CREATE TABLE r.Playlist_trn(
RowNum INT NOT NULL,
PlaylistID INT NOT NULL,
CONSTRAINT r_Playlist_trn_PlaylistID PRIMARY KEY (RowNum)
);

CREATE TABLE r.Playlist_tst(
RowNum INT NOT NULL,
PlaylistID INT NOT NULL,
CONSTRAINT r_Playlist_tst_PlaylistID PRIMARY KEY (RowNum)
);
GO

-- ***************************************************************
DROP TABLE IF EXISTS dbo.TrainTestSplit;
GO

CREATE TABLE dbo.TrainTestSplit(
PlaylistID INT NOT NULL,
RowNum INT NOT NULL,
TrainTestTypeID TINYINT NOT NULL,
CONSTRAINT PK_TrainTestSplit_PlaylistID PRIMARY KEY (PlaylistID),
CONSTRAINT UNQ_TrainTestSplit_RowNum UNIQUE (TrainTestTypeID, RowNum),
CONSTRAINT FK_TrainTestSplit_PlaylistID
  FOREIGN KEY (PlaylistID)
  REFERENCES dbo.Playlist(PlaylistID),
CONSTRAINT FK_TrainTestSplit_TrainTestTypeID
  FOREIGN KEY (TrainTestTypeID)
  REFERENCES dbo.TrainTestType(TrainTestTypeID),
INDEX IDX_TrainTestSplit_TrainTestTypeID_PlaylistID (TrainTestTypeID, PlaylistID) 
);
