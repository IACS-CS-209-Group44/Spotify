USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.SurveyPlaylist;
GO

CREATE TABLE dbo.SurveyPlaylist(
SurveyPlaylistID SMALLINT NOT NULL,
SurveyResponseID SMALLINT NOT NULL,
PlaylistNum TINYINT NOT NULL,
PlaylistUri VARCHAR(64) NOT NULL,
CONSTRAINT PK_SurveyPlaylist_SurveyPlaylistID PRIMARY KEY (SurveyPlaylistID),
CONSTRAINT UNQ_SurveyPlaylist_SurveyResponseID_PlaylistNum
  UNIQUE (SurveyResponseID, PlaylistNum),
CONSTRAINT UNQ_SurveyPlaylist_PlaylistUri UNIQUE (PlaylistUri),
CONSTRAINT FK_SurveyPlaylist_SurveyResponseID
  FOREIGN KEY (SurveyResponseID) REFERENCES dbo.SurveyResponse(SurveyResponseID)  
);
GO

INSERT INTO dbo.SurveyPlaylist
(SurveyPlaylistID, SurveyResponseID, PlaylistNum, PlaylistUri)
SELECT
  row_number() OVER (ORDER BY sr.SurveyResponseID, pn.i)
    AS SurveyPlaylistID,
  sr.SurveyResponseID,
  pn.i AS PlaylistNum,
  CASE pn.i
    WHEN 1 THEN sr.PlaylistUri_1
    WHEN 2 THEN sr.PlaylistUri_2
    WHEN 3 THEN sr.PlaylistUri_3
  END AS PlaylistUri
    
FROM
  dbo.SurveyResponse AS sr
  INNER JOIN dbo.Counter AS pn ON 
    pn.i BETWEEN 1 AND 3
ORDER BY sr.SurveyResponseID, pn.i;
