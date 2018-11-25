BULK INSERT dbo.PlaylistStandardizedNameMap
--FROM 'D:\Dropbox\IACS-CS-209s-Spotify\mpd\database_export_views\PlaylistStandardizedNameMap.csv'
FROM 'C:\Temp\PlaylistStandardizedNameMap.csv'
WITH
(
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '\n',
  TABLOCK
)
