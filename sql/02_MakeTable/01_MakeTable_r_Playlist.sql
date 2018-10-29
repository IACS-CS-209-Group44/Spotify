USE SpotifyDB
GO

DROP TABLE IF EXISTS r.Playlist;
GO

CREATE TABLE r.Playlist(
PlaylistID INT NOT NULL,
PlaylistName VARCHAR(1024) NOT NULL,
-- The number of tracks, albums, and artists on this playlist
NumTracks SMALLINT NOT NULL,
NumAlbums SMALLINT NOT NULL,
NumArtists SMALLINT NOT NULL,
-- Additional information about the playlist
NumFollowers INT NOT NULL,
NumEdits SMALLINT NOT NULL,
DurationMS INT NOT NULL,
IsCollaborative BIT NOT NULL,
ModifiedAt INT NOT NULL,
-- Primary Key and indices
CONSTRAINT PK_r_Playlist_PlaylistID PRIMARY KEY (PlaylistID),
INDEX IDX_r_Playlist_PlaylistName (PlaylistName)
)
GO
