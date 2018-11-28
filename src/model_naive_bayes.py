"""
Michael S. Emanuel
Tue Nov 27 00:30:38 2018
"""

import numpy as np
import scipy.sparse as sp
# import pandas as pd
# from tqdm import tqdm
from load_dataframes import load_frames 
# from model_utils import load_playlist_entry, load_playlist_entry_slices, make_csr_mat, calc_y, calc_score


def make_csr(sp_i:np.ndarray, sp_j: np.ndarray, sp_data: np.ndarray, m: int, n: int):
    # Convert arrays of i, j, v; and shape m, n into a csr matrix
    return sp.csc_matrix((sp_data, (sp_i, sp_j)), shape=(m, n))


def make_csc(sp_i:np.ndarray, sp_j: np.ndarray, sp_data: np.ndarray, m: int, n: int):
    # Convert arrays of i, j, v; and shape m, n into a csr matrix
    return sp.csc_matrix((sp_data, (sp_i, sp_j)), shape=(m, n))


# *************************************************************************************************
# main

# Set desired sizes for train and test
n_trn: int = 900
n_tst: int = 100

# Load all the data frames
if 'frames' not in globals():
    frames = load_frames()
else:
    print(f'frames already loaded in memory.')    

track_pairs = frames['TrackPairs']
tp = track_pairs

# Number of tracks and playlists
n_p: int = len(frames['Playlist'])
n_t: int = len(frames['Track']) + 1
# Build sparse matrix
sp_i = tp.TrackID_1.values
sp_j = tp.TrackID_2.values
sp_data = tp.Frequency.values.astype(np.float32)
sp_idx = (sp_i, sp_j)
# The shape of the sparse matrix; rows are playlists, columns are tracks (1 if included)
sp_shape = (n, n)
# Use Compressed Sparse Row format; every row is a sparse vector containing mostly zeroes
A_csr = sp.csr_matrix((sp_data, sp_idx), shape=sp_shape)
A_csc = sp.csc_matrix((sp_data, sp_idx), shape=sp_shape)

# PlaylistEntry, indexed by PlaylistID
pe = frames['PlaylistEntry'].set_index(keys=['PlaylistID'])

# Predict a playlist
playlist_id = 0
x_id = pe.loc[playlist_id].TrackID.values


k = len(x_id)
sp_i = x_id
sp_j = np.zeros_like(x_id)
sp_data = np.ones_like(x_id, dtype=np.float32)
# x = sp.csc_matrix((sp_data, (sp_i, sp_j)), shape=(n,1))
x = make_csc(x_id, np.zeros_like(x_id), np.ones_like(x_id, dtype=np.float32), n, 1)
