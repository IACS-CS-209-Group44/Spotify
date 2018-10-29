DROP TABLE IF EXISTS Playlist;

CREATE TABLE dbo.Playlist(
PlaylistID INT NOT NULL,
PlaylistName varchar(100) NOT NULL,
-- Playlist attributes
NumTracks SMALLINT NOT NULL,
NumArtists SMALLINT NOT NULL,
NumFollowers INT NOT NULL,
NumEdits SMALLINT NOT NULL,
DurationMS INT NOT NULL,
IsCollaborative BIT NOT NULL,
ModifiedAt INT NOT NULL,
-- Primary key
CONSTRAINT PK_Playlist_PlaylistID PRIMARY KEY (PlaylistID),
-- Indices
INDEX IDX_Playlist_PlaylistName (PlaylistName),
INDEX IDX_Playlist_NumFollowers(NumFollowers),
);
