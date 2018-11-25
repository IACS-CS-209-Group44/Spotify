"""
Michael S. Emanuel
Sat Nov 24 19:53:54 2018
"""

import numpy as np
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

    # Return four dataframes: playlist and entry on train and test
    return playlist_trn, playlist_tst, entry_trn, entry_tst


def make_y(playlist, entry):
    """Make the target (y) vector given dataframes for playlist and try"""
    pass


# *************************************************************************************************
# main

# Set desired sizes for train and test
n_trn: int = 90
n_tst: int = 10

# Load the data
if 'playlist' not in globals():
    playlist_trn, playlist_tst, entry_trn, entry_tst = load_data(n_trn, n_tst)

# Variable binding
playlist = playlist_trn
entry = entry_trn

# Number of tracks at end of playlist to predict
num_tracks: int = 10
# Find n
n: int = len(playlist)
# Build an nx10 matrix of TrackIDs
y: np.ndarray = np.zeros((n,10))
