DROP VIEW IF EXISTS v.TopTracks;
GO

CREATE VIEW v.TopTracks AS
WITH t1 AS(
SELECT
  pe.TrackID,
  COUNT(pe.TrackID) AS Frequency
FROM
  dbo.PlaylistEntry AS pe
GROUP BY pe.TrackID)
SELECT
TOP 100000
  tr.TrackUri,
  tr.TrackName,
  t1.TrackID,  
  row_number() OVER (ORDER BY t1.Frequency DESC) AS Rank,
  t1.Frequency,
  SUM(t1.Frequency) OVER (ORDER BY t1.Frequency DESC) AS CumFreq,
  SUM(t1.Frequency) OVER (ORDER BY t1.Frequency DESC) / 663463.28 AS CumFreqPct
FROM
  t1
  INNER JOIN dbo.Track AS tr ON tr.TrackID = t1.TrackID;
GO
