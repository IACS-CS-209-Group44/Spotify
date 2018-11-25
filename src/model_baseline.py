"""
Michael S. Emanuel
Sat Nov 24 19:53:54 2018
"""

import numpy as np
# from scipy.sparse import coo_matrix
import scipy.sparse as sp
import pandas as pd
from typing import Optional

# Filenames for the main h5 data file and playlist entry
fname_data = '../data/data.h5'
fname_pe = '../data/playlist_entry.h5'


def load_data(n_trn: Optional[int] = None, n_tst: Optional[int] = None):
    """Load data; n_trn is the number of items in train and test, respectively"""

    # Load playlist dataframe (train and test)
    playlist_trn = pd.read_hdf(fname_data, 'Playlist_trn')
    playlist_tst = pd.read_hdf(fname_data, 'Playlist_tst')
    
    # Load the last 10 tracks on all playlists
    playlist_last10 = pd.read_hdf(fname_data, 'Playlist_Last10')

    # Merge the playlist attributes with the last 10 tracks (train and test)
    playlist_trn = pd.merge(left=playlist_trn, right=playlist_last10, on='PlaylistID')
    playlist_tst = pd.merge(left=playlist_tst, right=playlist_last10, on='PlaylistID')

    # Shorten playlist_trn and playlist_tst if number of entries was specified
    if n_trn is not None:
        playlist_trn = playlist_trn.iloc[0:n_trn]
    if n_tst is not None:
        playlist_tst = playlist_tst.iloc[0:n_tst]

    # Load the entry dataframe
    entry = pd.read_hdf(fname_pe, 'PlaylistEntry')

    # Get playlist entries for train and test
    entry_cols = ['PlaylistID', 'Position', 'TrackID']
    entry_trn = pd.merge(left=playlist_trn, right=entry, how='inner', on='PlaylistID')[entry_cols]
    entry_tst = pd.merge(left=playlist_tst, right=entry, how='inner', on='PlaylistID')[entry_cols]

    # Load the track tables
    track = pd.read_hdf(fname_data, 'Track')

    # Return four dataframes: playlist and entry on train and test
    return playlist_trn, playlist_tst, entry_trn, entry_tst, track


def calc_y(playlist, predict_count: int=10):
    """Make the target (y) vector given dataframes for playlist"""
    # Find n (number of playlists)
    n: int = len(playlist)
    # Build an nx10 matrix of TrackIDs
    y_id: np.ndarray = np.zeros((n, predict_count), dtype=np.int32)
    # Extrack the last 10 Track IDs from the playlist dataframe
    for j in range(predict_count):
        col_name = f'TrackID_{j+1}'
        y_id[:,j] = playlist[col_name].values
    
    # Sparse matrix with the sum of these entries
    sp_i = np.arange(n*predict_count, dtype=np.int32) // predict_count
    sp_j = y_id.flatten()
    sp_data = np.ones(shape=n*predict_count, dtype=np.float32)
    sp_idx = (sp_i, sp_j)
    # The track_count is a global variable in the outer scope
    sp_shape = (n, track_count)
    y = sp.csr_matrix((sp_data, sp_idx), shape=sp_shape)
    # Return tuple with sparse and ID matrices
    return y, y_id


def calc_track_freq_by_name(playlist, entry):
    """Compute the frequency of a track given the TrackName; very simple baseline model."""
    # Convert the playlist name to lower case
    playlist['PlaylistName'] = playlist['PlaylistName'].str.lower()
    # Join against entries
    cols = ['PlaylistName', 'TrackID']
    name_track = pd.merge(left=playlist, right=entry, on='PlaylistID')[cols]
    return name_track.groupby(by=['PlaylistName', 'TrackID']).size()


def predict_baseline(name):
    """Predict y in the simple baseline model"""
    pass

# *************************************************************************************************
# main

# Set desired sizes for train and test
n_trn: int = 9000
n_tst: int = 1000

# Load the data
if 'playlist' not in globals():
    playlist_trn, playlist_tst, entry_trn, entry_tst, track = load_data(n_trn, n_tst)


# The number of tracks in the data set
track_count: int = len(track)
# Number of tracks to predict
predict_count: int = 10

# The next 10 tracks we want to predict
if 'y_sp_trn' not in globals():
    y_trn, y_id_trn = calc_y(playlist_trn, predict_count)
    y_tst, y_id_tst = calc_y(playlist_tst, predict_count)


#    # variable binding
#    playlist = playlist_trn
#    entry = entry_trn
#    # Convert the playlist name to lower case
#    playlist['PlaylistName'] = playlist['PlaylistName'].str.lower()
#    # Join against entries
#    cols = ['PlaylistName', 'TrackID']
#    name_track = pd.merge(left=playlist, right=entry, on='PlaylistID')[cols]
#    name_track_freq = name_track.groupby(by=['PlaylistName', 'TrackID']).size()
    
track_freq_by_name = calc_track_freq_by_name(playlist_trn, entry_trn)
xxx = track_freq_by_name.reset_index(name='Count')
