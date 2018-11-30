USE SpotifyDB;
GO

DROP TABLE IF EXISTS r.SurveyResponse;
GO

CREATE TABLE r.SurveyResponse(
SurveyResponseID SMALLINT NOT NULL,
StartDate DATETIME NOT NULL,
EndDate DATETIME NOT NULL,
Status VARCHAR(20) NOT NULL,
IP_Address VARCHAR(15) NOT NULL,
Progress TINYINT NOT NULL,
Duration SMALLINT NOT NULL,
Finished VARCHAR(5) NOT NULL,
RecordedDate DATETIME NOT NULL,
ResponseID VARCHAR(20) NOT NULL,
LocationLatitude FLOAT NOT NULL,
LocationLongitude FLOAT NOT NULL,
DistributionChannel VARCHAR(16) NULL,
UserLanguage CHAR(2) NOT NULL,
SurveyConsent VARCHAR(16) NOT NULL,
RecipientName VARCHAR(64) NOT NULL,
RecipientEmail VARCHAR(64) NOT NULL,
SpotifyUserName VARCHAR(64) NOT NULL,
SpotifyPlaylistUrl_1 VARCHAR(256) NOT NULL,
SpotifyPlaylistUrl_2 VARCHAR(256) NOT NULL,
SpotifyPlaylistUrl_3 VARCHAR(256) NOT NULL,
CONSTRAINT PK_r_SurveyResponse_SurveyResponseID PRIMARY KEY (SurveyResponseID),
CONSTRAINT UNQ_r_SurveyResponse_RecipientEmail UNIQUE (RecipientEmail),
CONSTRAINT UNQ_r_SurveyResponse_ResponseID UNIQUE (ResponseID),
CONSTRAINT UNQ_r_SurveyResponse_SpotifyUserName UNIQUE (SpotifyUserName),
);
