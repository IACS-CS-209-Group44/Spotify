"""
Michael S. Emanuel
Sat Nov 24 19:53:54 2018
"""

import numpy as np
import scipy.sparse as sp
import pandas as pd
from tqdm import tqdm
from load_dataframes import load_frames 
from model_utils import load_playlist_entry, calc_y


# *************************************************************************************************
def predict_by_name(frames, playlist, predict_count: int = 10) -> np.ndarray:
    """Predict y in a simple baseline model using only the playlist name"""
    # Get the baseline candidate trackes for unrecognized playlist names
    track_rank = frames['TrackRank']
    candidates_baseline = track_rank.TrackID[0:512].values
    
    
    # Number of playlists
    n: int = len(playlist)
    # Get the PlaylistName table to map PlaylistName to SimpleName
    playlist_name_tbl = frames['PlaylistName'].set_index(keys=['PlaylistName'])
    # Get the TrackRankBySimpleName data
    track_by_name = frames['TrackRankBySimpleName']
    # Reindex entry to be indexed by (PlaylistID, Position)
    entry_idx = entry.set_index(keys=['PlaylistID', 'Position'])
    # Reindex track by name to be indexed on (SimpleName, TrackRank)
    track_by_name_idx = track_by_name.set_index(keys=['SimpleName','TrackRank'])
    # Simple names of the playlists
    playlist_names = playlist.PlaylistName.values
    simple_names = playlist_name_tbl.loc[playlist_names].SimpleName.values
    # Add the SimpleName field to the playlist frame
    # playlist['SimpleName'] = playlist['PlaylistName'].str.lower()
    # Matrix of predicted TrackIDs
    y_pred = np.zeros((n, predict_count))
    # Status update
    print(f'Generating predictions for {n_trn} playlists...')
    # Iterate through the playlists
    for i in tqdm(range(n)):
        # The  simple name of this playlist (lower case, keep punctuation)
        simple_name: str = simple_names[i]
        # The playlist_id and number of tracks in this playlist
        playlist_id: np.int64 = playlist.iloc[i].PlaylistID
        num_tracks: np.int64 = playlist.iloc[i].NumTracks
        # Tracks on this playlist before predict_count - don't want duplicates
        duplicate_tracks = entry_idx.loc[playlist_id].values[0:num_tracks-predict_count]
        # Candidate tracks in descending frequency order
        try:
            candidate_tracks = track_by_name_idx.loc[simple_name].TrackID.values
        except:
            # If the playlist name is not available, put in an empty array as a placeholder
            # will fall back on baseline frequency below
            candidate_tracks = np.zeros(shape=0, dtype=np.int64)
        # Append candidate tracks with baseline; make sure we don't run out of candidates
        candidate_tracks = np.hstack([candidate_tracks, candidates_baseline])
        # Mask for candidate tracks that are duplicates of ones already present
        duplicate_mask = np.isin(candidate_tracks, duplicate_tracks)
        # The predicted tracks
        predicted_tracks = candidate_tracks[~duplicate_mask][0:predict_count]
        # Save to y_pred
        y_pred[i, :] = predicted_tracks
    # Return the predicted ys as a matrix
    return y_pred


# *************************************************************************************************
# main

# Set desired sizes for train and test
n_trn: int = 9000
n_tst: int = 1000

# Load all the data frames
if 'frames' not in globals():
    frames = load_frames()
else:
    print(f'frames already loaded in memory.')    

# Load the playlist and entry frames for train and test
# if 'playlist_trn' not in globals():
playlist_trn, playlist_tst, entry_trn, entry_tst = load_playlist_entry(frames, n_trn, n_tst)

# Number of tracks to predict
predict_count: int = 10

# The next 10 tracks we want to predict
if 'y_sp_trn' not in globals():
    y_trn, y_id_trn = calc_y(frames, playlist_trn, predict_count)
    y_tst, y_id_tst = calc_y(frames, playlist_tst, predict_count)

# Run predictions by name
y_pred_trn = predict_by_name(frames, playlist_trn)
y_pred_tst = predict_by_name(frames, playlist_tst)

#    # variable binding
#    predict_count: int = 10
#    playlist = playlist_trn
#    entry = entry_trn

