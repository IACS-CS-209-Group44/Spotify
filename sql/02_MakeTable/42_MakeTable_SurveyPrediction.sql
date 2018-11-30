USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.SurveyPrediction;
GO

CREATE TABLE dbo.SurveyPrediction(
SurveyPlaylistID SMALLINT NOT NULL,
Position SMALLINT NOT NULL,
TrackID INT NOT NULL,
Frequency INT NOT NULL,
CONSTRAINT PK_SurveyPrediction_SurveyPlaylistID_Position
  PRIMARY KEY (SurveyPlaylistID, Position),
CONSTRAINT UNQ_SurveyPrediction_SurveyPlaylistID_TrackID
  UNIQUE (SurveyPlaylistID, TrackID),
CONSTRAINT FK_SurveyPrediction_SurveyPlaylistID
  FOREIGN KEY (SurveyPlaylistID)
  REFERENCES dbo.SurveyPlaylist(SurveyPlaylistID),
CONSTRAINT FK_SurveyPrediction_TrackID
  FOREIGN KEY (TrackID)
  REFERENCES dbo.Track(TrackID)
);
GO

-- Make first batch of predictions using the TrackPair model
INSERT INTO dbo.SurveyPrediction
(SurveyPlaylistID, Position, TrackID, Frequency)
SELECT
  sp.SurveyPlaylistID,
  sp.Position,
  sp.TrackID,
  sp.Frequency
FROM
  v.SurveyPrediction_TrackPair AS sp;

-- Predict the rest using SimpleName model
INSERT INTO dbo.SurveyPrediction
(SurveyPlaylistID, Position, TrackID, Frequency)
SELECT
  spl.SurveyPlaylistID,
  row_number() OVER 
    (partition BY spl.SurveyPlaylistID ORDER BY trsn.Frequency DESC)
    AS Position,
  trsn.TrackID,
  trsn.Frequency
FROM
  dbo.SurveyPlaylist AS spl  
  INNER JOIN dbo.PlaylistSimpleName AS psn ON
    psn.PlaylistSimpleName = spl.PlaylistSimpleName
  -- The track frequencies for this playlist
  INNER JOIN dbo.TrackRankBySimpleName AS trsn ON
    trsn.PlaylistSimpleNameID = psn.PlaylistSimpleNameID AND
    trsn.TrackRank <= 256
WHERE 
  -- Only survey playlists that are missing
  NOT EXISTS 
  (SELECT * FROM dbo.SurveyPrediction AS pr 
   WHERE pr.SurveyPlaylistID = spl.SurveyPlaylistID);
