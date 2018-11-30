"""
Michael S. Emanuel
Sat Nov 24 12:28:39 2018
"""

import pandas as pd
import time
from IPython.display import display
from typing import List, Dict, Optional


def load_frames(frame_names: Optional[List[str]] = None) -> Dict[str, pd.DataFrame]:
    """Load all available data frames.  Return a dictionary keyed by frame_name."""
    # Relative path to h5 data files
    path_h5 = '../data/'
    
    # Dictionary of dataframes to be generated.
    # Key = frame name, value = fname_h5
    frame_tbl: Dict[str, str] = {
        # Basic schema
        'Artist': 'data.h5',
        'Album': 'data.h5',
        'Track': 'data.h5',
        'Playlist': 'data.h5',
    
        # Tables relating to prediction outcomes and scoring
        'TrainTestSplit': 'data.h5',
        'Playlist_Last10': 'data.h5',
        'Playlist_trn': 'data.h5',
        'Playlist_tst': 'data.h5',
        
        # Tables relating to the baseline and playlist name prediction models
        'TrackRank': 'data.h5',
        'PlaylistName': 'data.h5',
        'PlaylistSimpleName': 'data.h5',
        'TrackRankBySimpleName': 'data.h5',
    
        # PlaylistEntry table is big - saved int its own file
        'PlaylistEntry': 'playlist_entry.h5',
    
        # Audio features
        'AudioFeatures': 'data.h5',
        'Genre': 'data.h5',
        'MetaGenre': 'data.h5',
        'TrackGenre': 'data.h5',
        'TrackMetaGenre': 'data.h5',
        
        # TrackPairs table is big - saved in its own file
        'TrackPairs': 'track_pairs.h5',
        
        # Scores of three models: baseline, playlist name, naive bayes
        'Scores_Baseline': 'data.h5',
        'Scores_SimpleName': 'data.h5',
        'Scores_TrackPair': 'data.h5',
        'Scores_Stack': 'data.h5',
        
        # Survey responses
        'SurveyResponse': 'data.h5',
        'SurveyPlaylist': 'data.h5',
        'SurveyPlaylistEntry': 'data.h5',

        # Artists being promoted by policy (mid-tier, female)
        'PromotedArtist': 'data.h5',

        # Survey recommendations
        'SurveyRecommendations': 'data.h5',
        'SurveyRecommendationsPromoted': 'data.h5',
        }
    
    # Set frame_names to all tables if it was not specified
    if frame_names is None:
        frame_names = frame_tbl.keys()
    
    # Start timer
    t0 = time.time()
    # Dictionary of data frames
    frames: Dict[str, pd.DataFrame] = dict()
    # Iterate over entries in frame_names, loading them from h5 files
    for frame_name in frame_names:
        # h5 filename for this frame
        fname_h5 = frame_tbl[frame_name]
        # Read the data frame
        frames[frame_name] = pd.read_hdf(path_h5 + fname_h5, frame_name)
        # Status update
        print(f'Loaded {frame_name}.')
    
    # Status update
    t1 = time.time()
    elapsed = t1 - t0
    print(f'\nLoaded {len(frames)} Data Frames.')
    print(f'Elapsed Time: {elapsed:0.2f} seconds.')
    return frames


def demo_frames(frames, names):
    """Demo the contents of some dataframes"""
    for i, df in enumerate(frames):
        name = names[i]
        print(f'\n***** {name}: First 20 Rows *****')
        display(df.head(20))

def main():
    # Load all data frames
    frames = load_frames()

    # Dataframes to be printed to screen (top 20 rows only)
    demo_names = ['Artist', 'Album']
    frames_to_demo = [frames[demo_name] for demo_name in demo_names]
    
    # Demo dataframes
    print('')
    demo_frames(frames_to_demo, demo_names)


if __name__ == '__main__':
    main()
