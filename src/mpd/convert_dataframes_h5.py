"""
Michael S. Emanuel
Sat Nov 24 12:28:39 2018
"""

# Convert CSV dumps of Database Tables into the more efficient H5 file format.

import os
import pandas as pd

# Path for Dropbox
path_dropbox_mpd = 'D:/Dropbox/IACS-CS-209-Spotify/mpd/database_export'
# Navigate to the dropbox folder
os.chdir(path_dropbox_mpd)

# Filename for the main h5 data file
fname_h5 = 'data.h5'

# Load the dataframes for Artist, Album, Track, and Playlist
df_artist = pd.read_csv('Artist.csv', sep=',', index_col='ArtistID')
df_album = pd.read_csv('Album.csv', sep=',', index_col='AlbumID')
df_track = pd.read_csv('Track.csv', sep=',', index_col='TrackID')
df_playlist = pd.read_csv('Playlist.csv', sep=',', index_col='PlaylistID')

# Convert these to h5 format
df_artist.to_hdf(fname_h5, key='Artist')
df_album.to_hdf(fname_h5, key='Album')
df_track.to_hdf(fname_h5, key='Track')
df_playlist.to_hdf(fname_h5, key='Playlist')

# Status update
print(f'Converted DataFrames for Artist, Album, Track, and Playlist to CSV format in data.h5.')
print(f'(Keys are Prtist, Allum, Track, and Playlist.')

# Load the big dataframes PlaylistEntry
df_playlist_entry = pd.read_csv('PlaylistEntry.csv', sep=',', index_col=['PlaylistID', 'Position'])

# Convert df_playlist_entry to h5 format; save this in a separate h5 data file so
# data.h5 doesn't become too large
df_playlist_entry.to_hdf('playlist_entry.h5', 'PlaylistEntry')

# Load the dataframes for audio features: AudioFeatures, Genre, MetaGenre, TrackGenre, TrackMetaGenre
df_audio_features = pd.read_csv('AudioFeatures.csv', sep=',', index_col='TrackID')
df_genre = pd.read_csv('Genre.csv', sep=',', index_col='GenreID')
df_meta_genre = pd.read_csv('MetaGenre.csv', sep=',', index_col='MetaGenreID')
df_track_genre = pd.read_csv('TrackGenre.csv', sep=',', index_col=['TrackID', 'GenreID'])
df_track_meta_genre = pd.read_csv('TrackMetaGenre.csv', sep=',', index_col=['TrackID', 'MetaGenreID'])

# Convert the audio features to h5 format
df_audio_features.to_hdf(fname_h5, key='AudioFeatures')
df_genre.to_hdf(fname_h5, key='Genre')
df_meta_genre.to_hdf(fname_h5, key='MetaGenre')
df_track_genre.to_hdf(fname_h5, key='TrackGenre')
df_track_meta_genre.to_hdf(fname_h5, key='TrackMetaGenre')



