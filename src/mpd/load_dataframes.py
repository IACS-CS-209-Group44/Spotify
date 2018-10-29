"""
Michael S. Emanuel
Sun Oct 28 22:12:19 2018
"""

import os
import pandas as pd

# Path for Dropbox
path_dropbox_mpd = 'D:/Dropbox/IACS-CS-209-Spotify/mpd/database_export'
# Navigate to the dropbox folder
os.chdir(path_dropbox_mpd)

# Load the dataframes for Artist, Album, Track
if 'df_artist' not in globals():
    df_artist = pd.read_csv('Artist.csv', sep=',', index_col='ArtistID')
if 'df_album' not in globals():
    df_album = pd.read_csv('Album.csv', sep=',', index_col='AlbumID')
if 'df_track' not in globals():
    df_track = pd.read_csv('Track.csv', sep=',', index_col='TrackID')

# Load the dataframes for Playlist and PlaylistEntry
if 'df_playlist' not in globals():
    df_playlist = pd.read_csv('Playlist.csv', sep=',', index_col='PlaylistID')
if 'df_playlist_entry' not in globals():
    df_playlist_entry = pd.read_csv('PlaylistEntry.csv', sep=',', index_col=['PlaylistID', 'Position'])

# Demo dataframes
dataframes = [df_artist, df_album, df_track, df_playlist, df_playlist_entry]
df_names = ['Artist', 'Album', 'Track', 'Playlist', 'PlaylistEntry']
for i, df in enumerate(dataframes):
    df_name = df_names[i]
    print(f'\n***** {df_name}: First 20 Rows *****')
    print(df.head(20))
