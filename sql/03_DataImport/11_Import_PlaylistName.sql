USE SpotifyDB;
GO

-- Populate PlaylistName with initial batch of values; 
-- PlaylistSimpleNameID still nullable at this point
WITH t1 AS(
SELECT
  row_number() OVER (ORDER BY pl.PlaylistName) AS PlaylistNameID,
  pl.PlaylistName
FROM
  dbo.Playlist AS pl
GROUP BY pl.PlaylistName)
INSERT INTO PlaylistName
(PlaylistNameID, PlaylistName, PlaylistSimpleNameID, PlaylistSimpleName)
SELECT
  t1.PlaylistNameID,
  t1.PlaylistName,
  -- Use a null placeholder for PlaylistSimpleNameID; update it later
  NULL AS PlaylistSimpleNameID,
  -- Generate PlaylistSimpleName by the following transformations
  -- (1) trim the name (remove leading spaces from both ends
  -- (2) remove all punctuation
  -- (3) convert all letters to lower case
  LTRIM(RTRIM(
  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
  REPLACE(REPLACE(REPLACE(
  LOWER(t1.PlaylistName),
  ':',''), '~',''), '!',''), '@',''), '#',''), '$',''), '%',''), '*',''), '(',''), ')',''), '_',''), 
  '+',''), '{',''), '}',''), '[',''), ']',''), ';',''), ':',''), '"',''), '<',''), '>',''), '`',''),
  '?',''), ',',''), '.',''), '&',''), '-',''), '/',''), '=',''), '^',''), '\',''), '|',''), 'c/o',''), 
  '•',''), '¯',''), '°',''), '°',''), '¿',''), 
  '''','')
  ))
  AS PlaylistSimpleName
FROM
  t1;

-- Populate PlaylistSimpleName from PlaylistName
INSERT INTO dbo.PlaylistSimpleName
(PlaylistSimpleNameID, PlaylistSimpleName)
SELECT
  row_number() OVER (ORDER BY pn.PlaylistSimpleName) AS PlaylistSimpleNameID,
  pn.PlaylistSimpleName
  FROM dbo.PlaylistName AS pn
GROUP BY pn.PlaylistSimpleName;

-- Update the PlaylistSimpleNameID field on PlaylistName
UPDATE
  pn
SET
  pn.PlaylistSimpleNameID = psn.PlaylistSimpleNameID
FROM
  dbo.PlaylistName AS pn
  INNER JOIN dbo.PlaylistSimpleName AS psn ON
    psn.PlaylistSimpleName = pn.PlaylistSimpleName;

-- Now that PlaylistNameID is populated, it can be made not null
ALTER TABLE dbo.PlaylistName ALTER COLUMN PlaylistSimpleNameID integer NOT NULL;
-- Add foreign keys on PlaylistNameID and PlaylistName
ALTER TABLE dbo.PlaylistName
ADD CONSTRAINT FK_PlaylistName_PlaylistSimpleNameID 
  FOREIGN KEY (PlaylistSimpleNameID)
  REFERENCES dbo.PlaylistSimpleName(PlaylistSimpleNameID);
ALTER TABLE dbo.PlaylistName
ADD CONSTRAINT FK_PlaylistName_PlaylistSimpleName 
  FOREIGN KEY (PlaylistSimpleName)
  REFERENCES dbo.PlaylistSimpleName(PlaylistSimpleName);

-- Add index on PlaylistNameID
CREATE INDEX IDX_PlaylistName_PlaylistSimpleNameID ON dbo.PlaylistName (PlaylistSimpleNameID);
