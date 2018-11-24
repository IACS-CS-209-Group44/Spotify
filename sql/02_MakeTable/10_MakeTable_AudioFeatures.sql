USE SpotifyDB
GO

DROP TABLE IF EXISTS dbo.AudioFeatures;
GO

CREATE TABLE dbo.AudioFeatures(
TrackID INT NOT NULL,
TrackUri CHAR(36) NOT NULL,
TrackGid CHAR(32) NOT null,
TrackPopularityRank INT NOT NULL,
NumArtists TINYINT NOT null,
Acousticness FLOAT NOT null,
BeatStrength FLOAT NOT null,
Bounciness FLOAT NOT null,
Danceability FLOAT NOT null,
Duration FLOAT NOT null,
Energy FLOAT NOT null,
Flatness FLOAT NOT null,
Instrumentalness FLOAT NOT null,
KeySignature TINYINT NOT null,
Speechiness FLOAT NOT null,
Liveness FLOAT NOT null,
Loudness FLOAT NOT null,
Valence FLOAT NOT null,
Tempo FLOAT NOT null,
TimeSignature FLOAT NOT null,
Genres VARCHAR(512) NOT null,
MetaGenres VARCHAR(512) NOT null,
-- Primary key is the TrackID
CONSTRAINT PK_AudioFeatures_TrackID PRIMARY KEY (TrackID),
-- TrackURI is unique
CONSTRAINT UNQ_AudioFeatures_TrackUri UNIQUE (TrackUri),
-- TrackID is a foreign key on dbo.Track
CONSTRAINT FK_AudioFeatures_TrackID
  FOREIGN KEY (TrackID)
  REFERENCES dbo.Track(TrackID),
-- TrackUri is a foreign key on dbo.Track
CONSTRAINT FK_AudioFeatures_TrackUri
  FOREIGN KEY (TrackUri)
  REFERENCES dbo.Track(TrackUri)  
);
