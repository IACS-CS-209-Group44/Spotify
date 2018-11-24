USE SpotifyDB;
GO

-- Empty tables in reverse depenedency order
TRUNCATE TABLE dbo.TrackGenre;
TRUNCATE TABLE dbo.TrackMetaGenre;
GO
TRUNCATE TABLE dbo.AudioFeatures;
GO

-- Populate dbo.AudioFeatures from r.AudioFeatures
INSERT INTO AudioFeatures
(TrackID, TrackUri, TrackGid, TrackPopularityRank, NumArtists, Acousticness, BeatStrength, 
 Bounciness, Danceability, Duration, Energy, Flatness, Instrumentalness, KeySignature,
 Speechiness, Liveness, Loudness, Valence, Tempo, TimeSignature, Genres, MetaGenres)
SELECT
  tr.TrackID,
  tr.TrackUri,
  af.gid AS TrackGid,
  af.popularity_rank AS TrackPopularityRank,
  af.artists AS NumArtists,
  af.acousticness AS Acousticness,
  af.beat_strength AS BeatStrength,
  af.bounciness AS Bounciness,
  af.danceability AS Danceability,
  af.duration AS Duration,
  af.energy AS Energy,
  af.flatness AS Flatness,
  af.instrumentalness AS Instrumentalness,
  af.[key] AS KeySignature,
  af.speechiness AS Speechiness,
  af.liveness AS Liveness,
  af.loudness AS Loudness,
  af.valence AS Valence,
  af.tempo AS Tempo,
  af.time_signature AS TimeSignature,
  af.genres AS Genres,
  af.meta_genres AS MetaGenres
FROM
  r.AudioFeatures AS af
  INNER JOIN dbo.Track AS tr ON 
    tr.TrackUri = af.TrackUri;
GO

-- Populate dbo.TrackGenre
-- Staging table for (TrackID, GenreName)
DROP TABLE IF EXISTS r.TrackGenreName;
CREATE TABLE r.TrackGenreName(
TrackID INT NOT NULL,
GenreName VARCHAR(64) NOT NULL,
PRIMARY KEY (TrackID, GenreName)
);

-- Populate TrackGenreName from AudioFeatures and Genre
WITH t1 AS(
SELECT
  af.TrackID,
  TRIM(value) AS Genre
FROM 
  dbo.AudioFeatures AS af
  CROSS apply STRING_SPLIT(SUBSTRING(af.Genres, 2, len(af.Genres)-2), ',')
WHERE
  LEN(TRIM(value)) >= 2
),
t2 AS(
SELECT
  t1.TrackID,
  substring(t1.Genre, 2, len(t1.Genre)-2) AS GenreName
FROM
  t1
WHERE
  t1.Genre <> ''
)
INSERT INTO r.TrackGenreName
(TrackID, GenreName)
SELECT
  t2.TrackID,
  t2.GenreName
FROM t2;

-- Populate TrackGenre from TrackGenreName
INSERT INTO dbo.TrackGenre
(TrackID, GenreID)
SELECT
  tgn.TrackID,
  g.GenreID
FROM
  r.TrackGenreName AS tgn
  INNER JOIN dbo.Genre AS g ON
    g.GenreName = tgn.GenreName;
GO

-- Populate dbo.TrackMetaGenre
-- Staging table for (TrackID, MetaGenreName)
DROP TABLE IF EXISTS r.TrackMetaGenreName;
CREATE TABLE r.TrackMetaGenreName(
TrackID INT NOT NULL,
MetaGenreName VARCHAR(64) NOT NULL,
PRIMARY KEY (TrackID, MetaGenreName)
);

-- Populate TrackMetaGenreName from AudioFeatures and MetaGenre
WITH t1 AS(
SELECT
  af.TrackID,
  TRIM(value) AS MetaGenre
FROM 
  dbo.AudioFeatures AS af
  CROSS apply STRING_SPLIT(SUBSTRING(af.MetaGenres, 2, len(af.Genres)-2), ',')
WHERE
  LEN(TRIM(value)) >= 2
),
t2 AS(
SELECT
  t1.TrackID,
  substring(t1.MetaGenre, 2, len(t1.MetaGenre)-2) AS MetaGenreName
FROM
  t1
WHERE
  t1.MetaGenre <> ''
)
INSERT INTO r.TrackMetaGenreName
(TrackID, MetaGenreName)
SELECT
  t2.TrackID,
  t2.MetaGenreName
FROM t2;

-- Populate TrackGenre from TrackMetaGenreName
INSERT INTO dbo.TrackMetaGenre
(TrackID, MetaGenreID)
SELECT
  tmgn.TrackID,
  mg.MetaGenreID
FROM
  r.TrackMetaGenreName AS tmgn
  INNER JOIN dbo.MetaGenre AS mg ON
    mg.MetaGenreName = tmgn.MetaGenreName;
GO
