#!/bin/bash
# echo 'Script to get the first 10 Unity file with .fbx extension from World of Code with their project name as output'

# Attemp to store the value of blob to File name into a SQlite database in da4
# Takes too long to complete

# zcat /da?_data/basemaps/gz/b2fFullU*.s | fgrep .fbx | while IFS=";" read -r blob filename; do
#     safe_filename=$(echo "$filename" | sed "s/'/''/g")
#     sqlite3 /home/zguo20/WoC-Unity-Collect/my_database.db <<EOF
#     INSERT INTO fbx_blob_fname (blob_id, filename) VALUES ('$blob', '$safe_filename');
# EOF
# done


#Change the search to ".asset" files
zcat /da?_data/basemaps/gz/b2fFullU*.s | grep -iE "Assets/.+\.asset" >> asset_blobs_new.txt # Search all the asset files that is in the format of containing .asset in a directory that is named Asset
grep -v "\.asset\.meta$" asset_blobs_new.txt > filtered_blobs.txt #Get rif of the files containning .meta
cat filtered_blobs.txt |cut -d \; -f 1 | ~/lookup/getValues b2P >> asset_projects.txt #Look up project name in a deforked fashion. Output format will be blob;Original Project name; All projects that forked original
cut -d ";" -f 2 asset_projects.txt > asset_project_only.txt #Only take the second field which is original project
sort -u asset_project_only.txt -o asset_project_only_no_dup.txt # Make sure there is no duplicate project
