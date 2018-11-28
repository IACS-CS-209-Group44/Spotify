USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.SurveyResponse;
GO

CREATE TABLE dbo.SurveyResponse(
SurveyResponseID SMALLINT NOT NULL,
RecipientName VARCHAR(64) NOT NULL,
RecipientEmail VARCHAR(64) NOT NULL,
SpotifyUserName VARCHAR(64) NOT NULL,
SpotifyPlaylistUrl_1 VARCHAR(256) NOT NULL,
SpotifyPlaylistUrl_2 VARCHAR(256) NOT NULL,
SpotifyPlaylistUrl_3 VARCHAR(256) NOT NULL,
CONSTRAINT PK_SurveyResponse_SurveyResponseID PRIMARY KEY (SurveyResponseID),
CONSTRAINT UNQ_SurveyResponse_RecipientEmail UNIQUE (RecipientEmail),
CONSTRAINT UNQ_SurveyResponse_SpotifyUserName UNIQUE (SpotifyUserName),
CONSTRAINT UNQ_SurveyResponse_SpotifyPlaylistUrl_1 UNIQUE (SpotifyPlaylistUrl_1),
CONSTRAINT UNQ_SurveyResponse_SpotifyPlaylistUrl_2 UNIQUE (SpotifyPlaylistUrl_2),
CONSTRAINT UNQ_SurveyResponse_SpotifyPlaylistUrl_3 UNIQUE (SpotifyPlaylistUrl_3),
);
GO

INSERT INTO dbo.SurveyResponse
(SurveyResponseID, RecipientName, RecipientEmail, SpotifyUserName,
 SpotifyPlaylistUrl_1, SpotifyPlaylistUrl_2, SpotifyPlaylistUrl_3)
SELECT
  sr.SurveyResponseID, 
  sr.RecipientName, 
  sr.RecipientEmail, 
  sr.SpotifyUserName,
  sr.SpotifyPlaylistUrl_1, 
  sr.SpotifyPlaylistUrl_2, 
  sr.SpotifyPlaylistUrl_3
FROM
  r.SurveyResponse AS sr;
GO
