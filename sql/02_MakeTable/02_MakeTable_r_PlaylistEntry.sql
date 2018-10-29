USE SpotifyDB
GO

DROP TABLE IF EXISTS r.PlaylistEntry;
GO

CREATE TABLE r.PlaylistEntry(
PlaylistID INT NOT NULL,
Position SMALLINT NOT NULL,
-- The track
TrackUri VARCHAR(256) NOT NULL,
TrackName VARCHAR(1024) NOT NULL,
-- The album
AlbumUri VARCHAR(256) NOT NULL,
AlbumName VARCHAR(1024) NOT NULL,
-- The artist
ArtistUri VARCHAR(256) NOT NULL,
ArtistName VARCHAR(1024) NOT NULL,
-- Additional track info
TrackDurationMS INT NOT null
-- Primary Key and indices
CONSTRAINT PK_r_PlaylistEntry PRIMARY KEY (PlaylistID, Position),
INDEX IDX_r_PlaylistEntry_Tracks (TrackUri, TrackName),
INDEX IDX_r_PlaylistEntry_Albums (AlbumUri, AlbumName),
INDEX idx_r_PlaylistEntry_Artists (ArtistUri, ArtistName)
)
