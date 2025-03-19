import sqlite3 
import sys
sys.path.append("./functions")
import unity_parser
import os
# directory = "../filter_method/processed_blobs/downloaded_files/extracted_files/"
directory = os.path.abspath("./filter_method/processed_blobs/downloaded_files/extracted_files/")

connect = sqlite3.connect('UnityVSG.db')

cursor = connect.cursor()

cursor.execute("DROP TABLE IF EXISTS graph")
cursor.execute('''
    CREATE TABLE IF NOT EXISTS graph (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        node_count INTEGER,
        edges_count INTEGER,
        file_name TEXT
    )
''')



for file in os.listdir(directory):
    file_path = os.path.join(directory, file)
    if os.path.isfile(file_path):  
        try:
            ret = unity_parser.parse_unity_asset(file_path) 
            nodes_count = ret["num_nodes"]
            edges = ret["num_edges"]

            try:
                cursor.execute("INSERT INTO graph (node_count,  edges_count, file_name) VALUES (?, ?, ?)", 
                           (nodes_count,edges, file))
                print(f"Inserted: {file} - Node count: {nodes_count}, Edges: {edges}")
            except sqlite3.IntegrityError:
                print(f"Skipping {file}, already exists in DB.")
        except Exception as e: 
            print(f"Error processing {file_path}: {e}") 

connect.commit() 
connect.close()
