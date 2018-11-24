USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.MetaGenre;
GO

CREATE TABLE dbo.MetaGenre(
MetaGenreID INT NOT NULL,
MetaGenreName VARCHAR(64) NOT NULL,
CONSTRAINT PK_MetaGenre_MetaGenreID PRIMARY KEY (MetaGenreID),
CONSTRAINT UNQ_MetaGenre_MetaGenreName UNIQUE (MetaGenreName)
);

-- Query over r.AudioFeatures
WITH t1 AS (
SELECT
  distinct TRIM(value) AS meta_genre
FROM
  r.AudioFeatures
  CROSS apply STRING_SPLIT(SUBSTRING(meta_genres, 2, len(meta_genres)-2), ',')
),
t2 AS(
SELECT
  substring(t1.meta_genre, 2, len(t1.meta_genre)-2) AS meta_genre
FROM t1
WHERE t1.meta_genre <> ''
)
-- Populate dbo.MetaGenre from r.AudioFeatures
INSERT INTO dbo.MetaGenre
(MetaGenreID, MetaGenreName)
SELECT
  row_number() OVER (ORDER BY t2.meta_genre) AS MetaGenreID,
  t2.meta_genre AS MetaGenreName
FROM
  t2;
