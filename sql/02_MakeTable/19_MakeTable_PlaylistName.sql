USE SpotifyDB;
GO

DROP TABLE IF EXISTS PlaylistName;
GO

CREATE TABLE dbo.PlaylistName(
PlaylistName VARCHAR(512) NOT NULL,
SimpleName VARCHAR(512) NOT NULL,
CONSTRAINT PK_PlaylistName_PlaylistName PRIMARY KEY (PlaylistName)
);
GO

WITH t1 AS(
SELECT
  pl.PlaylistName
FROM
  dbo.Playlist AS pl
GROUP BY pl.PlaylistName)
INSERT INTO PlaylistName
(PlaylistName, SimpleName)
SELECT
  t1.PlaylistName,
  LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(t1.PlaylistName),
  ':',''),'~',''),'!',''),'@',''),'#',''),'$',''),'%',''),'*',''),'(',''),')',''),'_',''),'+',''),
  '{',''),'}',''),'[',''),']',''),';',''),'''s',' S'),':',''),'"',''),'<',''),'>',''),'?',''),
  'c/o',''),',',''),'.',''),'&',''),'-',''),'/','')))
FROM
  t1;
