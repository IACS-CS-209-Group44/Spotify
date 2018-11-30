USE SpotifyDB;
GO

DROP TABLE IF EXISTS r.PromotedArtist;
GO

CREATE TABLE r.PromotedArtist(
artist_gid CHAR(32) NOT NULL,
artist_uri CHAR(37) NOT NULL,
artist_name VARCHAR(512) NOT NULL,
artist_gender VARCHAR(8) NOT NULL,
artist_genre VARCHAR(16) NULL,
tier TINYINT NOT NULL,
CONSTRAINT PK_r_PromotedArtist_artist_uri
  PRIMARY KEY (artist_uri),
CONSTRAINT UNQ_r_PromotedArtist_artist_gid
  UNIQUE (artist_gid)
);
