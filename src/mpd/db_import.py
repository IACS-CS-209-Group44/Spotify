"""
Harvard CS 209a
Final Project - Spotify

Michael S. Emanuel
Sun Oct 28 10:52:44 2018
"""

import pyodbc
import json
import os
from sys import argv
import numpy as np
from typing import List, Tuple, Dict


# *********************************************************************************************************************
# Mapping from strings to bool for IsCollaborative field
str2bool: Dict[str, bool] = {
        'true': True,
        'false': False,
        }


def get_insertions(fname: str) -> Tuple[List[Tuple], List[Tuple]]:
    """
    Read the mpd slice with this filename.
    Returns two lists of tuples, inserts_playlist and inserts_tracks.
    Each entry is a tuple matching one record on the r.Playlist and r.PlaylistEntry tables, respectively.
    """
    # Reference external variable used
    global str2bool
    # Open the file
    with open(fname) as fh:
        # Read the json contents
        js = fh.read()
    # Read in the data as a JSON object
    mpd_slice = json.loads(js)
    # Extract the playlists field from the slice
    playlists = mpd_slice['playlists']
    # Length (should be 1000)
    playlist_count: int = len(playlists)

    # Preallocate list of rows to be inserted for the Playlist table
    rows_playlist: List[Tuple] = playlist_count * [None]
    # Initialize an empty list of rows to be inserted for the PlaylistEntry table (we don't know its length yet)
    rows_playlist_entry: List[Tuple] = list()

    # Iterate over each playlist in the slice
    for i, playlist in enumerate(playlists):
        # Get the attributes of this playlist
        # Name attributes consistent with the database naming scheme
        # ID and name
        PlaylistID: int = playlist['pid']
        PlaylistName: str = playlist['name']
        # Number of tracks, albums, and artits
        NumTracks: int = playlist['num_tracks']
        NumAlbums: int = playlist['num_albums']
        NumArtists: int = playlist['num_artists']
        # Additional info
        NumFollowers: int = playlist['num_followers']
        NumEdits: int = playlist['num_edits']
        DurationMS: int = playlist['duration_ms']
        IsCollaborative: bool = str2bool[playlist['collaborative']]
        ModifiedAt: int = playlist['modified_at']

        # Assemble this into a tuple with one row to be inserted into r.Playlist
        row_playlist: Tuple = (PlaylistID, PlaylistName, NumTracks, NumAlbums, NumArtists,
                               NumFollowers, NumEdits, DurationMS, IsCollaborative, ModifiedAt)
        # Save this tow to the inserts
        rows_playlist[i] = row_playlist

        # Get the tracks out of this playlist
        tracks: List[Dict] = playlist['tracks']
        # Iterate over the tracks
        for track in tracks:
            # Get the contents of this track - use database names and order
            # already have PlaylistID above
            Position: int = track['pos']
            # The track
            TrackUri: str = track['track_uri']
            TrackName: str = track['track_name']
            # The album
            AlbumUri: str = track['album_uri']
            AlbumName: str = track['album_name']
            # The artist
            ArtistUri: str = track['artist_uri']
            ArtistName: str = track['artist_name']
            # Duration
            TrackDurationMS: int = track['duration_ms']

            # Assemble this into a tuple with one row to be inserted into r.PlaylistEntry
            row_playlist_entry: Tuple = (PlaylistID, Position, TrackUri, TrackName, AlbumUri, AlbumName,
                                         ArtistUri, ArtistName, TrackDurationMS)
            rows_playlist_entry.append(row_playlist_entry)

    # Return the lists ready to be inserted into r.Playlist and r.PlaylistEntry
    return (rows_playlist, rows_playlist_entry)


# *********************************************************************************************************************
def getConnection() -> pyodbc.Connection:
    """Get database connection"""
    driver: str = r'{ODBC Driver 13 for SQL Server}'
    server: str = r'THOR\MJOLNIR'
    database: str = 'SpotifyDB'
    auth: str = 'Trusted_Connection=yes;'
    conn_string: str = f'DRIVER={driver};SERVER={server};DATABASE={database};{auth}'
    conn: pyodbc.Connection = pyodbc.connect(conn_string)
    return conn


# *********************************************************************************************************************
def delete_playlist(curs, PlaylistID_Min: int, PlaylistID_Max: int) -> None:
    """
    Deletes a block of rows in DB table r.Playlist
    INPUTS:
    ======
    curs:           Database cursor
    PlaylistID_min:   First PLaylistID to be deleted (inclusive)
    PlaylistID_max:   Last  PLaylistID to be deleted (exclusive)
    """

    # SQL string to delete records for this range of PlaylistID
    sqlDelete = '''
    DELETE FROM r.Playlist WHERE ? <= PlaylistID and ? < PlaylistID
    '''
    # Delete records in this range of PlaylistID
    curs.execute(sqlDelete, PlaylistID_Min, PlaylistID_Max)


def insert_playlist(curs, rows_playlist: List[Tuple]):
    """
    Inserts a list of rows into the DB table r.Playlist
    INPUTS:
    ======
    curs:           Database cursor
    rows_playlist:  Row of records to be inserted
    """

    # SQL string to insert ONE record into r.Playslist
    # row_playlist: Tuple = (PlaylistID, PlaylistName, NumTracks, NumAlbums, NumArtists,
    #                        NumFollowers, NumEdits, DurationMS, IsCollaborative, ModifiedAt)
    sqlInsert = '''
    INSERT INTO r.Playlist
    (PlaylistID, PlaylistName, NumTracks, NumAlbums, NumArtists,
    NumFollowers, NumEdits, DurationMS, IsCollaborative, ModifiedAt)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    '''
    # Insert batch of records using executemany method
    curs.executemany(sqlInsert, rows_playlist)
    # Commit changes
    curs.commit()



# *********************************************************************************************************************
def insert_playlist_entry(curs, rows_playlist_entry: List[Tuple]):
    """
    Inserts a list of rows into the DB table r.PlaylistEntry
    INPUTS:
    ======
    curs:           Database cursor
    rows_playlist:  Row of records to be inserted
    """

    # SQL string to insert ONE record into r.PlaylistEntry
    # row_playlist_entry: Tuple = (PlaylistID, Position, TrackUri, TrackName, AlbumUri, AlbumName,
    #                              ArtistUri, ArtistName, TrackDurationMS)
    sqlInsert = '''
    INSERT INTO r.PlaylistEntry
    (PlaylistID, Position, TrackUri, TrackName, AlbumUri, AlbumName, ArtistUri, ArtistName, TrackDurationMS)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    '''
    # Insert batch of records using executemany method
    curs.executemany(sqlInsert, rows_playlist)
    # Commit changes
    curs.commit()



# *********************************************************************************************************************
# Set the path of the MPD directory
mpd_path = r'D:/Dropbox/IACS-CS-209-Spotify/mpd/data'

# Move to this directory and get all filesnames; each file is a slice
os.chdir(mpd_path)
filenames: List[str] = os.listdir()

fname: str = filenames[0]
rows_playlist, rows_playlist_entry = get_insertions(fname)

# Range of PlaylistID
PlaylistID_Min = min(pl[0] for pl in rows_playlist)
PlaylistID_Max = max(pl[0] for pl in rows_playlist) + 1

# Get DB connection
with getConnection() as conn:
    # Cursor
    curs = conn.cursor()
    # Set mode to fast insertions on execute many; see
    curs.fast_executemany = True
    # Delete records in this range
    delete_playlist(curs, PlaylistID_Min, PlaylistID_Max)
    # Insert records in this range
    insert_playlist(curs, rows_playlist)


# *********************************************************************************************************************
def main():
    # Unpack arguments
    argc: int = len(argv)-1
    if argc == 0:
        sliceMin = 0
        sliceMax = 1000
    if argc == 1:
        sliceMin = 0
        sliceMax = int(argv[1])
    if argc == 2:
        sliceMin: int = int(argv[1])
        sliceMax: int = int(argv[2])
    if argc not in (0, 1, 2):
        print('Usage: python db_import.py sliceMin sliceMax.')
        print('This will insert slices from and including sliceMin, up to but not including sliceMax.')
        return
    # Range of PlaylistID's
    PlaylistID_Min: int = sliceMin * 1000
    PlaylistID_Max: int = sliceMax * 1000
    # Stats update
    print(f'Beginning database import from slice {sliceMin} to {sliceMax}, '
          f'i.e. from PlaylistID {PlaylistID_Min} to {PlaylistID_Max}.')


if __name__ == '__main__':
    main()
