"""
Michael S. Emanuel
Sun Oct 28 22:12:19 2018
"""

import os
import pandas as pd
from IPython.display import display

# Is this program running in IPython?
is_IPython = hasattr(__builtins__, '__IPYTHON__')

# Path for Dropbox
path_dropbox_mpd = 'D:/Dropbox/IACS-CS-209-Spotify/mpd/database_export'
# Navigate to the dropbox folder
os.chdir(path_dropbox_mpd)

# Load the dataframes for Artist, Album, Track, and Playlist
df_artist = pd.read_csv('Artist.csv', sep=',', index_col='ArtistID')
df_album = pd.read_csv('Album.csv', sep=',', index_col='AlbumID')
df_track = pd.read_csv('Track.csv', sep=',', index_col='TrackID')
df_playlist = pd.read_csv('Playlist.csv', sep=',', index_col='PlaylistID')

# Status update
print(f'Converted DataFrames for Artist, Album, Track, and Playlist to CSV format in data.h5.')
print(f'(Keys are Prtist, Allum, Track, and Playlist.')

# Load the big dataframes PlaylistEntry
df_playlist_entry = pd.read_csv('PlaylistEntry.csv', sep=',', index_col=['PlaylistID', 'Position'])

# Load the dataframes for audio features: AudioFeatures, Genre, MetaGenre, TrackGenre, TrackMetaGenre
df_audio_features = pd.read_csv('AudioFeatures.csv', sep=',', index_col='TrackID')
df_genre = pd.read_csv('Genre.csv', sep=',', index_col='GenreID')
df_meta_genre = pd.read_csv('MetaGenre.csv', sep=',', index_col='MetaGenreID')
df_track_genre = pd.read_csv('TrackGenre.csv', sep=',', index_col=['TrackID', 'GenreID'])
df_track_meta_genre = pd.read_csv('TrackMetaGenre.csv', sep=',', index_col=['TrackID', 'MetaGenreID'])


def demo_dataframes(df_names, dataframes):
    """Print out the first few rows """
    for i, df in enumerate(dataframes):
        df_name = df_names[i]
        print(f'\n***** {df_name}: First 20 Rows *****')
        display(df.head(20))

# Demo dataframes
df_names = ['Artist', 'Album', 'Track', 'Playlist', 'PlaylistEntry']
dataframes = [df_artist, df_album, df_track, df_playlist, df_playlist_entry]
demo_dataframes(df_names[0:2], dataframes[0:2])

