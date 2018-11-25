USE SpotifyDB;
GO

INSERT INTO dbo.TrainTestSplit
(PlaylistID, RowNum, TrainTestTypeID)
SELECT
  pl.PlaylistID,
  pl.RowNum,
  ttt.TrainTestTypeID
FROM
  r.Playlist_trn AS pl
  INNER JOIN dbo.TrainTestType AS ttt ON
    ttt.TrainTestTypeCD = 'TRN'
UNION
SELECT
  pl.PlaylistID,
  pl.RowNum,
  ttt.TrainTestTypeID
FROM
  r.Playlist_tst AS pl
  INNER JOIN dbo.TrainTestType AS ttt ON
    ttt.TrainTestTypeCD = 'TST';
