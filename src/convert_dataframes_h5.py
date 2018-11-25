"""
Michael S. Emanuel
Sat Nov 24 12:28:39 2018
"""

# Convert CSV dumps of Database Tables into the more efficient H5 file format.
import os
import pandas as pd
import time
import warnings
from typing import Dict, Tuple

# Filter warning from pytables -- performance is OK.
warnings.filterwarnings('ignore',category=pd.io.pytables.PerformanceWarning)

# Path for CSVs in Dropbox
path_dropbox_mpd = 'D:/Dropbox/IACS-CS-209-Spotify/mpd/database_export'
# Navigate to the dropbox folder
os.chdir(path_dropbox_mpd)

# Dictionary of dataframes to be generated.
# Key = frame name, value = [fname_csv, fname_h5]
frames: Dict[str, Tuple[str, str]] = {
    # Basic schema
    'Artist': ('Artist.csv', 'h5/data.h5'),
    'Album': ('Album.csv', 'h5/data.h5'),
    'Track': ('Track.csv', 'h5/data.h5'),
    'Playlist': ('Playlist.csv', 'h5/data.h5'),

    # Tables relating to prediction outcoumes and track frequencies 
    'Playlist_Last10': ('Playlist_Last10.csv', 'h5/data.h5'),
    'TrackRank': ('TrackRank.csv', 'h5/data.h5'),
    'TrackRankBySimpleName': ('TrackRankBySimpleName.csv', 'h5/data.h5'),

    # PlaylistEntry table is big - put it in its own file
    'PlaylistEntry': ('PlaylistEntry.csv', 'h5/playlist_entry.h5'),

    # Audio features
    'AudioFeatures': ('AudioFeatures.csv', 'h5/data.h5'),
    'Genre': ('Genre.csv', 'h5/data.h5'),
    'MetaGenre': ('MetaGenre.csv', 'h5/data.h5'),
    'TrackGenre': ('TrackGenre.csv', 'h5/data.h5'),
    'TrackMetaGenre': ('TrackMetaGenre.csv', 'h5/data.h5'),
    
    # TrackPairs table is big - put it in its own file
    'TrackPairs': ('TrackPairs.csv', 'h5/track_pairs.h5'),
    }

# Number of frames to process
frame_count: int = len(frames)
print(f'Beginning conversion of {} data frames from CSV to H5...')
# Start timer
t0 = time.time()
# Iterate over the frames to convert
for df_name, fnames in frames.items():
    # Unpack the filenames for CSV and h5
    fname_csv, fname_h5 = fnames
    # Load the frame into a csv file
    df = pd.read_csv(fname_csv, sep=',')
    # Convert the CSV to h5 format
    df.to_hdf(fname_h5, key=df_name)
    # Status update
    elapsed = time.time() - t0
    print(f'Converted DatFrame {df_name:24} from CSV to H5 format in {fname_h5}; {elapsed:0.2f} seconds.')

# Stop timer & report
t1 = time.time()
elapsed = t1 - t0
print(f'Loaded {frame_count} Data Frames.')
print(f'Elapsed Time: {elapsed:0.2f} seconds.')
