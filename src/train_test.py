"""
Michael S. Emanuel
Sat Nov 24 14:55:02 2018
"""

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split

# Filename for the main h5 data file
fname_h5 = '../data/data.h5'

# Split playlist dataframe into train and test
df_playlist = pd.read_hdf(fname_h5, 'Playlist')
df_playlist_trn, df_playlist_tst = train_test_split(df_playlist, test_size=0.10, random_state=42)

# Save these two frames to data.h5 file
df_playlist_trn.to_hdf(fname_h5, key='Playlist_trn')
df_playlist_tst.to_hdf(fname_h5, key='Playlist_tst')


def export_csv():
    """Generate CSV export files for train / test split"""
    # Reload files from H5; now they aren't copies anymore
    df_playlist_trn = pd.read_hdf(fname_h5, 'Playlist_trn')
    df_playlist_tst = pd.read_hdf(fname_h5, 'Playlist_tst')
    
    # Add the RowNum field
    df_playlist_trn['RowNum'] = np.arange(1, len(df_playlist_trn)+1)
    df_playlist_tst['RowNum'] = np.arange(1, len(df_playlist_tst)+1)
    
    # Export to CSV for upload to database
    df_playlist_trn.to_csv('../data/Playlist_trn.csv', columns=['RowNum'])
    df_playlist_tst.to_csv('../data/Playlist_tst.csv', columns=['RowNum'])
