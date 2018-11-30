USE SpotifyDB;
GO

DROP TABLE IF EXISTS r.SurveyPlaylistEntry;
GO

CREATE TABLE r.SurveyPlaylistEntry(
SurveyPlaylistEntryID INT NOT NULL,
RecipientEmail VARCHAR(64) NOT NULL,
PlaylistName VARCHAR(100) NOT NULL,
PlaylistUri VARCHAR(64) NOT NULL,
Position SMALLINT NOT NULL,
TrackUri CHAR(36) NOT NULL,
CONSTRAINT PK_r_SurveyPlaylistEntry PRIMARY KEY (SurveyPlaylistEntryID),
CONSTRAINT UNQ_r_SurveyPlaylistEntry_PlaylistUri_Position UNIQUE (PlaylistUri, Position)
);
