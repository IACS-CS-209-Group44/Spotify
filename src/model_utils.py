"""
Michael S. Emanuel
Sun Nov 25 10:56:35 2018
"""

import numpy as np
import scipy.sparse as sp
import pandas as pd
from typing import Dict, Optional


def load_playlist_entry(frames: Dict[str, pd.DataFrame], n_trn: Optional[int] = None, n_tst: Optional[int] = None):
    """Load data for playlists and entries; n_trn is the number of items in train and test, respectively"""

    # Load playlist dataframe (train and test)
    playlist_trn = frames['Playlist_trn']
    playlist_tst = frames['Playlist_tst']
    
    # Load the last 10 tracks on all playlists
    playlist_last10 = frames['Playlist_Last10']

    # Merge the playlist attributes with the last 10 tracks (train and test)
    playlist_trn = pd.merge(left=playlist_trn, right=playlist_last10, on='PlaylistID')
    playlist_tst = pd.merge(left=playlist_tst, right=playlist_last10, on='PlaylistID')

    # Shorten playlist_trn and playlist_tst if number of entries was specified
    if n_trn is not None:
        playlist_trn = playlist_trn.iloc[0:n_trn]
    if n_tst is not None:
        playlist_tst = playlist_tst.iloc[0:n_tst]

    # Load the entry dataframe
    entry = frames['PlaylistEntry']

    # Get playlist entries for train and test
    entry_cols = ['PlaylistID', 'Position', 'TrackID']
    entry_trn = pd.merge(left=playlist_trn, right=entry, how='inner', on='PlaylistID')[entry_cols]
    entry_tst = pd.merge(left=playlist_tst, right=entry, how='inner', on='PlaylistID')[entry_cols]

    # Return four dataframes: playlist and entry on train and test
    return playlist_trn, playlist_tst, entry_trn, entry_tst


def calc_y(frames: Dict[str, pd.DataFrame], playlist: pd.DataFrame, predict_count: int=10):
    """Make the target (y) vector given dataframe for playlist"""
    # The number of tracks
    track_count: int = len(frames['Track'])
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
    # The shape of the sparse matrix; rows are playlists, columns are tracks (1 if included)
    sp_shape = (n, track_count)
    # Use Compressed Sparse Row format; every row is a sparse vector containing mostly zeroes
    y = sp.csr_matrix((sp_data, sp_idx), shape=sp_shape)
    # Return tuple with sparse and ID matrices
    return y, y_id


def score():
    """"""
    pass