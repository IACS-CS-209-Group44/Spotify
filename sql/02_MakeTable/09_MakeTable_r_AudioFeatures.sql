USE SpotifyDB
GO

DROP TABLE IF EXISTS r.AudioFeatures;
GO

CREATE TABLE r.AudioFeatures(
TrackUri CHAR(36) NOT NULL,
track_uri CHAR(36) NOT NULL,
uri CHAR(36) NOT NULL,
gid CHAR(32) NOT null,
[name] VARCHAR(512) NOT null,
popularity_rank FLOAT NOT NULL,
artists FLOAT NOT null,
acousticness FLOAT NOT null,
beat_strength FLOAT NOT null,
bounciness FLOAT NOT null,
danceability FLOAT NOT null,
duration FLOAT NOT null,
energy FLOAT NOT null,
flatness FLOAT NOT null,
instrumentalness FLOAT NOT null,
[key] FLOAT NOT null,
speechiness FLOAT NOT null,
liveness FLOAT NOT null,
loudness FLOAT NOT null,
valence FLOAT NOT null,
tempo FLOAT NOT null,
time_signature FLOAT NOT null,
genres VARCHAR(512) NOT null,
meta_genres VARCHAR(512) NOT null,
-- Primary key is the TrackURI
CONSTRAINT PK_r_AudioFeatures PRIMARY KEY (TrackUri),
);
