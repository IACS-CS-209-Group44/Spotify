USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.SurveyPlaylistEntry;
GO

CREATE TABLE dbo.SurveyPlaylistEntry(
SurveyPlaylistID SMALLINT NOT NULL,
Position SMALLINT NOT NULL,
TrackID INT NOT NULL,
CONSTRAINT PK_SurveyPlaylistEntry_SurveyPlaylistID_Position 
  PRIMARY KEY (SurveyPlaylistID, Position),
CONSTRAINT FK_SurveyPlaylistEntry_SurveyPlaylistID
  FOREIGN KEY (SurveyPlaylistID) REFERENCES dbo.SurveyPlaylist(SurveyPlaylistID),
CONSTRAINT FK_SurveyPlaylistEntry_TrackID
  FOREIGN KEY (TrackID) REFERENCES dbo.Track(TrackID)
);

INSERT INTO dbo.SurveyPlaylistEntry
(SurveyPlaylistID, Position, TrackID)
SELECT
  pl.SurveyPlaylistID,
  pe.Position,
  tr.TrackID
FROM 
  -- Start with playlist entries from the survey
  r.SurveyPlaylistEntry AS pe
  -- Get the survey playlist associated with this entry using the PlaylistUri
  INNER JOIN dbo.SurveyPlaylist AS pl ON 
    pl.PlaylistUri = pe.PlaylistUri
  -- Get the TrackID for RECOGNIZED TRACKS ONLY on this playlist
  -- Unrecognized tracks WILL NOT BE JOINED here!
  INNER JOIN dbo.Track AS tr ON
    tr.TrackUri = pe.TrackUri;
