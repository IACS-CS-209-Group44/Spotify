USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.SurveyResponse;
GO

CREATE TABLE dbo.SurveyResponse(
SurveyResponseID SMALLINT NOT NULL,
RecipientName VARCHAR(64) NOT NULL,
RecipientEmail VARCHAR(64) NOT NULL,
SpotifyUserName VARCHAR(64) NOT NULL,
PlaylistUrl_1 VARCHAR(256) NOT NULL,
PlaylistUrl_2 VARCHAR(256) NOT NULL,
PlaylistUrl_3 VARCHAR(256) NOT NULL,
PlaylistUri_1 VARCHAR(64) NOT NULL,
PlaylistUri_2 VARCHAR(64) NOT NULL,
PlaylistUri_3 VARCHAR(64) NOT NULL,
CONSTRAINT PK_SurveyResponse_SurveyResponseID PRIMARY KEY (SurveyResponseID),
CONSTRAINT UNQ_SurveyResponse_RecipientEmail UNIQUE (RecipientEmail),
CONSTRAINT UNQ_SurveyResponse_SpotifyUserName UNIQUE (SpotifyUserName),
CONSTRAINT UNQ_SurveyResponse_PlaylistUrl_1 UNIQUE (PlaylistUrl_1),
CONSTRAINT UNQ_SurveyResponse_PlaylistUrl_2 UNIQUE (PlaylistUrl_2),
CONSTRAINT UNQ_SurveyResponse_PlaylistUrl_3 UNIQUE (PlaylistUrl_3),
CONSTRAINT UNQ_SurveyResponse_PlaylistUri_1 UNIQUE (PlaylistUrl_1),
CONSTRAINT UNQ_SurveyResponse_PlaylistUri_2 UNIQUE (PlaylistUrl_2),
CONSTRAINT UNQ_SurveyResponse_PlaylistUri_3 UNIQUE (PlaylistUrl_3),
);
GO

INSERT INTO dbo.SurveyResponse
(SurveyResponseID, RecipientName, RecipientEmail, SpotifyUserName,
 PlaylistUrl_1, PlaylistUrl_2, PlaylistUrl_3,
 PlaylistUri_1, PlaylistUri_2, PlaylistUri_3)
SELECT
  sr.SurveyResponseID, 
  sr.RecipientName, 
  sr.RecipientEmail, 
  sr.SpotifyUserName,
  sr.SpotifyPlaylistUrl_1 AS PlaylistUrl_1,
  sr.SpotifyPlaylistUrl_2 AS PlaylistUrl_2, 
  sr.SpotifyPlaylistUrl_3 AS PlaylistUrl_3,
  RIGHT(sr.SpotifyPlaylistUrl_1, len(sr.SpotifyPlaylistUrl_1) - patindex('%playlist/%', sr.SpotifyPlaylistUrl_1)-8) 
    AS PlaylistUri_1,
  RIGHT(sr.SpotifyPlaylistUrl_2, len(sr.SpotifyPlaylistUrl_2) - patindex('%playlist/%', sr.SpotifyPlaylistUrl_2)-8) 
    AS PlaylistUri_2,
  RIGHT(sr.SpotifyPlaylistUrl_3, len(sr.SpotifyPlaylistUrl_3) - patindex('%playlist/%', sr.SpotifyPlaylistUrl_3)-8) 
    AS PlaylistUri_3    
FROM
  r.SurveyResponse AS sr;
