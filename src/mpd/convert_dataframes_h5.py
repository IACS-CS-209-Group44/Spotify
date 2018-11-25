"""
Michael S. Emanuel
Sat Nov 24 12:28:39 2018
"""

# Convert CSV dumps of Database Tables into the more efficient H5 file format.
import os
import pandas as pd

# Path for CSVs in Dropbox
path_dropbox_mpd = 'D:/Dropbox/IACS-CS-209-Spotify/mpd/database_export'
# Navigate to the dropbox folder
os.chdir(path_dropbox_mpd)

# Filename for the main h5 data file
fname_h5 = 'h5/data.h5'

# Load the dataframes for Artist, Album, Track, and Playlist
df_artist = pd.read_csv('Artist.csv', sep=',')
df_album = pd.read_csv('Album.csv', sep=',')
df_track = pd.read_csv('Track.csv', sep=',')
df_playlist = pd.read_csv('Playlist.csv', sep=',')
df_playlist_last10 = pd.read_csv('Playlist_Last10.csv', sep=',')

# Convert these to h5 format
df_artist.to_hdf(fname_h5, key='Artist')
df_album.to_hdf(fname_h5, key='Album')
df_track.to_hdf(fname_h5, key='Track')
df_playlist.to_hdf(fname_h5, key='Playlist')
df_playlist_last10.to_hdf(fname_h5, key='Playlist_Last10')

# Status update
print(f'Converted DataFrames for Artist, Album, Track, Playlist, Playlist_Last10 from CSV to H5 format in data.h5.')

# Load the big dataframes PlaylistEntry
df_playlist_entry = pd.read_csv('PlaylistEntry.csv', sep=',')
# Convert df_playlist_entry to h5 format
# Save this in a separate h5 data file so data.h5 doesn't become too large
df_playlist_entry.to_hdf('playlist_entry.h5', 'PlaylistEntry')
# Status update
print(f'Converted DataFrame for PlaylistEntry from CSV format to H5 format in playlist_entry.h5.')


# Load the dataframes for audio features: AudioFeatures, Genre, MetaGenre, TrackGenre, TrackMetaGenre
df_audio_features = pd.read_csv('AudioFeatures.csv', sep=',')
df_genre = pd.read_csv('Genre.csv', sep=',')
df_meta_genre = pd.read_csv('MetaGenre.csv', sep=',')
df_track_genre = pd.read_csv('TrackGenre.csv', sep=',')
df_track_meta_genre = pd.read_csv('TrackMetaGenre.csv', sep=',')

# Convert the audio features to h5 format
df_audio_features.to_hdf(fname_h5, key='AudioFeatures')
df_genre.to_hdf(fname_h5, key='Genre')
df_meta_genre.to_hdf(fname_h5, key='MetaGenre')
df_track_genre.to_hdf(fname_h5, key='TrackGenre')
df_track_meta_genre.to_hdf(fname_h5, key='TrackMetaGenre')

# Load the big dataframe for TrackPairs
df_track_pairs = pd.read_csv('TrackPairs.csv')
# Convert df_track_pairs to h5 format
# Save this in a separate h5 data file so data.h5 doesn't become too large
df_track_pairs.to_hdf('track_pairs.h5', 'TrackPairs')

# Status update
print(f'Converted DFs for AudioFeatures, Genre, MetaGenre, TrackGenre, TrackMetaGenre to H5 format in data.h5.')
