"""
Michael S. Emanuel
Sat Nov 24 12:28:39 2018
"""

import pandas as pd
import time
from IPython.display import display

# Filenames for h5 data files
fname_data = '../data/data.h5'
fname_entry = '../data/playlist_entry.h5'
fname_pairs = '../data/track_pairs.h5'

# Start timer
t0 = time.time()

# Load the dataframes for Artist, Album, Track, and Playlist
df_artist = pd.read_hdf(fname_data, 'Artist')
df_album = pd.read_hdf(fname_data, 'Album')
df_track = pd.read_hdf(fname_data, 'Track')
df_playlist = pd.read_hdf(fname_data, 'Playlist')
df_playlist_last10 = pd.read_hdf(fname_data, 'Playlist_Last10')

# Load the big dataframe for PlaylistEntry
df_playlist_entry = pd.read_hdf(fname_entry, 'PlaylistEntry')

# Load the dataframes for audio features: AudioFeatures, Genre, MetaGenre, TrackGenre, TrackMetaGenre
df_audio_features = pd.read_hdf(fname_data, 'AudioFeatures')
df_genre = pd.read_hdf(fname_data, 'Genre')
df_meta_genre = pd.read_hdf(fname_data, 'MetaGenre')
df_track_genre = pd.read_hdf(fname_data, 'TrackGenre')
df_track_meta_genre = pd.read_hdf(fname_data, 'TrackMetaGenre')

# Load the big dataframe for TrackPairs
df_track_pairs = pd.read_hdf(fname_pairs, 'TrackPairs')

# Status update
t1 = time.time()
elapsed = t1 - t0
print(f'Loaded 10 Data Frames:')
print(f'Artist, Album, Track Playlist, PlaylistEnry, AudioFeatures, Genre, MetaGenre, TrackGenre, TrackMetaGenre.')  
print(f'Elapsed Time: {elapsed:0.2f} seconds.')


def demo_dataframes(dataframes, df_names):
    """Demo the contents of some dataframes"""
    for i, df in enumerate(dataframes):
        df_name = df_names[i]
        print(f'\n***** {df_name}: First 20 Rows *****')
        display(df.head(20))

# Dataframes to be printed to screen (top 20 rows only)
dataframes = [df_artist, df_album]
df_names = ['Artist', 'Album']
# Demo dataframes
print('')
demo_dataframes(dataframes, df_names)
