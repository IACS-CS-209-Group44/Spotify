USE SpotifyDB;
GO

INSERT INTO dbo.Playlist_Last10
(PlaylistID, 
 TrackID_1, TrackID_2, TrackID_3, TrackID_4, TrackID_5, 
 TrackID_6, TrackID_7, TrackID_8, TrackID_9, TrackID_10)
SELECT
  pl.PlaylistID,
  pe1.TrackID AS TrackID_1,
  pe2.TrackID AS TrackID_2,
  pe3.TrackID AS TrackID_3,
  pe4.TrackID AS TrackID_4,
  pe5.TrackID AS TrackID_5,
  pe6.TrackID AS TrackID_6,
  pe7.TrackID AS TrackID_7,
  pe8.TrackID AS TrackID_8,
  pe9.TrackID AS TrackID_9,
  pe10.TrackID AS TrackID_10
FROM 
  dbo.Playlist AS pl
  INNER JOIN dbo.PlaylistEntry AS pe1 ON
    pe1.PlaylistID = pl.PlaylistID AND
    pe1.Position = pl.NumTracks - 11 + 1
  INNER JOIN dbo.PlaylistEntry AS pe2 ON
    pe2.PlaylistID = pl.PlaylistID AND
    pe2.Position = pl.NumTracks - 11 + 2
  INNER JOIN dbo.PlaylistEntry AS pe3 ON
    pe3.PlaylistID = pl.PlaylistID AND
    pe3.Position = pl.NumTracks - 11 + 3
  INNER JOIN dbo.PlaylistEntry AS pe4 ON
    pe4.PlaylistID = pl.PlaylistID AND
    pe4.Position = pl.NumTracks - 11 + 4
  INNER JOIN dbo.PlaylistEntry AS pe5 ON
    pe5.PlaylistID = pl.PlaylistID AND
    pe5.Position = pl.NumTracks - 11 + 5
  INNER JOIN dbo.PlaylistEntry AS pe6 ON
    pe6.PlaylistID = pl.PlaylistID AND
    pe6.Position = pl.NumTracks - 11 + 6
  INNER JOIN dbo.PlaylistEntry AS pe7 ON
    pe7.PlaylistID = pl.PlaylistID AND
    pe7.Position = pl.NumTracks - 11 + 7
  INNER JOIN dbo.PlaylistEntry AS pe8 ON
    pe8.PlaylistID = pl.PlaylistID AND
    pe8.Position = pl.NumTracks - 11 + 8
  INNER JOIN dbo.PlaylistEntry AS pe9 ON
    pe9.PlaylistID = pl.PlaylistID AND
    pe9.Position = pl.NumTracks - 11 + 9
  INNER JOIN dbo.PlaylistEntry AS pe10 ON
    pe10.PlaylistID = pl.PlaylistID AND
    pe10.Position = pl.NumTracks - 11 + 10
WHERE
  --Only playlists with at least 20 entries (10 seed values, 10 more to verify predictions against)
  pl.NumTracks >= 20;
