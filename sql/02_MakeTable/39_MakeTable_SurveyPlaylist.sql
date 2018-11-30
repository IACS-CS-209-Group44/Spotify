USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.SurveyPlaylistEntry;
DROP TABLE IF EXISTS dbo.SurveyPlaylist;
GO

CREATE TABLE dbo.SurveyPlaylist(
SurveyPlaylistID SMALLINT NOT NULL,
SurveyResponseID SMALLINT NOT NULL,
PlaylistNum TINYINT NOT NULL,
PlaylistUri VARCHAR(64) NOT NULL,
PlaylistName VARCHAR(512) NULL,
PlaylistSimpleName VARCHAR(512) NULL,
CONSTRAINT PK_SurveyPlaylist_SurveyPlaylistID PRIMARY KEY (SurveyPlaylistID),
CONSTRAINT UNQ_SurveyPlaylist_SurveyResponseID_PlaylistNum
  UNIQUE (SurveyResponseID, PlaylistNum),
CONSTRAINT UNQ_SurveyPlaylist_PlaylistUri UNIQUE (PlaylistUri),
CONSTRAINT FK_SurveyPlaylist_SurveyResponseID
  FOREIGN KEY (SurveyResponseID) REFERENCES dbo.SurveyResponse(SurveyResponseID)  
);
GO

-- Main block of playlist data
WITH t AS (
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
),
-- CTE to get playlist names
pn AS (
SELECT
  pe.PlaylistUri,
  pe.PlaylistName
FROM
  r.SurveyPlaylistEntry AS pe
GROUP BY pe.PlaylistUri, pe.PlaylistName  
)
INSERT INTO dbo.SurveyPlaylist
(SurveyPlaylistID, SurveyResponseID, PlaylistNum, PlaylistUri, PlaylistName)
SELECT
  t.SurveyPlaylistID,
  t.SurveyResponseID,
  t.PlaylistNum,
  t.PlaylistUri,
  pn.PlaylistName
FROM 
  t
  LEFT JOIN pn ON pn.PlaylistUri = t.PlaylistUri
ORDER BY t.SurveyResponseID, t.PlaylistNum;

-- Data cleaning
UPDATE dbo.SurveyPlaylist SET PlaylistName = 'Russian Music' WHERE SurveyPlaylistID = 6;
UPDATE dbo.SurveyPlaylist SET PlaylistName = 'RUNNING' WHERE SurveyPlaylistID = 13;
UPDATE dbo.SurveyPlaylist SET PlaylistName = 'Christmas' WHERE SurveyPlaylistID = 15;
UPDATE dbo.SurveyPlaylist SET PlaylistName = 'Colombia' WHERE SurveyPlaylistID = 35;
UPDATE dbo.SurveyPlaylist SET PlaylistSimpleName = 'chill rb' WHERE SurveyPlaylistID = 112;

-- Populate playlist names
UPDATE pl
SET
  pl.PlaylistSimpleName = COALESCE(pn.PlaylistSimpleName, '')
FROM
  dbo.SurveyPlaylist AS pl
  LEFT JOIN dbo.PlaylistName AS pn ON
    pn.PlaylistName = pl.PlaylistName;