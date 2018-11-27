"""
Michael S. Emanuel
Sat Nov 24 12:28:39 2018
"""

# Convert CSV dumps of Database Tables into the more efficient H5 file format.
import pandas as pd
import os
import shutil
import time
import warnings
from train_test import make_train_test
from typing import Dict, List, Tuple, Optional


def convert_frames(frame_names: Optional[List[str]] = None):
    # Filter warning from pytables -- performance is OK.
    warnings.filterwarnings('ignore',category=pd.io.pytables.PerformanceWarning)
    
    # Path for CSVs in Dropbox
    path_dropbox_mpd = 'D:/Dropbox/IACS-CS-209-Spotify/mpd/database_export'
    # Navigate to the dropbox folder
    os.chdir(path_dropbox_mpd)
    # Relative path to h5 data files
    path_h5 = 'h5/'
    
    # Dictionary of dataframes to be generated.
    # Key = frame name, value = [fname_csv, fname_h5]
    frame_tbl: Dict[str, Tuple[str, str]] = {
        # Basic schema
        'Artist': ('Artist.csv', 'data.h5'),
        'Album': ('Album.csv', 'data.h5'),
        'Track': ('Track.csv', 'data.h5'),
        'Playlist': ('Playlist.csv', 'data.h5'),
    
        # Tables relating to prediction outcomes and track frequencies 
        'Playlist_Last10': ('Playlist_Last10.csv', 'data.h5'),
        'TrackRank': ('TrackRank.csv', 'data.h5'),
        'PlaylistName':('PlaylistName.csv', 'data.h5'),
        'PlaylistSimpleName':('PlaylistSimpleName.csv', 'data.h5'),
        'TrackRankBySimpleName': ('TrackRankBySimpleName.csv', 'data.h5'),
    
        # PlaylistEntry table is big - put it in its own file
        'PlaylistEntry': ('PlaylistEntry.csv', 'playlist_entry.h5'),
    
        # Audio features
        'AudioFeatures': ('AudioFeatures.csv', 'data.h5'),
        'Genre': ('Genre.csv', 'data.h5'),
        'MetaGenre': ('MetaGenre.csv', 'data.h5'),
        'TrackGenre': ('TrackGenre.csv', 'data.h5'),
        'TrackMetaGenre': ('TrackMetaGenre.csv', 'data.h5'),
        
        # TrackPairs table is big - put it in its own file
        'TrackPairs': ('TrackPairs.csv', 'track_pairs.h5'),
        }
    
    # Set frame_names to all tables if it was not specified
    if frame_names is None:
        frame_names = frame_tbl.keys()

    # Number of frames to process
    frame_count: int = len(frame_names)
    print(f'Beginning conversion of {frame_count} data frames from CSV to H5...')
    # Start timer
    t0 = time.time()
    # Iterate over the frames to convert
    for frame_name in frame_names:
        # Unpack the filenames for CSV and h5
        fname_csv, fname_h5 = frame_tbl[frame_name]
        # Load the frame into a csv file
        df = pd.read_csv(fname_csv, sep=',')
        # Convert the CSV to h5 format
        df.to_hdf(path_h5 + fname_h5, key=frame_name)
        # Status update
        elapsed = time.time() - t0
        print(f'Converted DatFrame {frame_name:24} from CSV to H5 format in {fname_h5}; {elapsed:0.2f} seconds.')
    
    # Make playlist_trn and playlist_tst from playlist
    if 'Playlist' in frame_names or 'Playlist_trn' in frame_names or 'Playlist_tst' in frame_names:
        frame_name = 'Playlist'
        fname_h5 = frame_tbl[frame_name][1]
        df_playlist = pd.read_hdf(path_h5 + fname_h5, frame_name)
        df_playlist_trn, df_playlist_tst = make_train_test(df_playlist)
        df_playlist_trn.to_hdf(path_h5 + fname_h5, key='Playlist_trn')
        df_playlist_tst.to_hdf(path_h5 + fname_h5, key='Playlist_tst')
        print(f'Generated playlist_trn and playlist_tst, saved to data.h5.')

    # Stop timer & report
    t1 = time.time()
    elapsed = t1 - t0
    print(f'Loaded {frame_count} Data Frames.')
    print(f'Elapsed Time: {elapsed:0.2f} seconds.')


if __name__ == '__main__':
    # Convert all frames
    convert_frames()
    # convert_frames(['TrackRankBySimpleName'])
    # Copy from Dropbox to sandbox
    file_names = ['data.h5', 'playlist_entry.h5', 'track_pairs.h5']
    path_from = "D:\Dropbox\IACS-CS-209-Spotify\mpd\database_export\h5"
    path_to = "D:\IACS\CS-209a-Spotify\data"
    for file_name in file_names:
        full_name_from = os.path.join(path_from, file_name)
        full_name_to = os.path.join(path_to, file_name)
        shutil.copy(full_name_from, full_name_to)
    print(f'Copied files from Dropbox folder to GitHub sandbox /data.')