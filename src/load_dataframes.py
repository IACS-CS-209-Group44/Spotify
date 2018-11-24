"""
Michael S. Emanuel
Sat Nov 24 12:28:39 2018
"""

import pandas as pd
import time
from IPython.display import display

# Filename for the main h5 data file
fname_h5 = '../data/data.h5'
fname_pe_h5 = '../data/playlist_entry.h5'

# Start timer
t0 = time.time()

# Load the dataframes for Artist, Album, Track, and Playlist
df_artist = pd.read_hdf(fname_h5, 'Artist')
df_album = pd.read_hdf(fname_h5, 'Album')
df_track = pd.read_hdf(fname_h5, 'Track')
df_playlist = pd.read_hdf(fname_h5, 'Playlist')

# Load the big dataframe for PlaylistEntry
df_playlist_entry = pd.read_hdf(fname_pe_h5, 'PlaylistEntry')

# Load the dataframes for audio features: AudioFeatures, Genre, MetaGenre, TrackGenre, TrackMetaGenre
df_audio_features = pd.read_hdf(fname_h5, 'AudioFeatures')
df_genre = pd.read_hdf(fname_h5, 'Genre')
df_meta_genre = pd.read_hdf(fname_h5, 'MetaGenre')
df_track_genre = pd.read_hdf(fname_h5, 'TrackGenre')
df_track_meta_genre = pd.read_hdf(fname_h5, 'TrackMetaGenre')

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
