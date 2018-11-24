USE SpotifyDB;
GO

DROP TABLE IF EXISTS dbo.Genre;
GO

CREATE TABLE dbo.Genre(
GenreID INT NOT NULL,
GenreName VARCHAR(64) NOT NULL,
CONSTRAINT PK_Genre_GenreID PRIMARY KEY (GenreID),
CONSTRAINT UNQ_Genre_GenreName UNIQUE (GenreName)
);

-- Query over r.AudioFeatures
WITH t1 AS (
SELECT
  distinct TRIM(value) AS genre
FROM
  r.AudioFeatures
  CROSS apply STRING_SPLIT(SUBSTRING(genres, 2, len(genres)-2), ',')
),
t2 AS(
SELECT
  substring(t1.genre, 2, len(t1.genre)-2) AS genre
FROM t1
WHERE t1.genre <> ''
)
-- Populate dbo.Genre from r.AudioFeatures
INSERT INTO dbo.Genre
(GenreID, GenreName)
SELECT
  row_number() OVER (ORDER BY t2.genre) AS GenreID,
  t2.genre AS GenreName
FROM
  t2;
