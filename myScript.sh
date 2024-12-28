#!/bin/bash
# echo 'Script to get the first 10 Unity file with .fbx extension from World of Code with their project name as output'

# #Search the data file and find all the files with .fbx ending select the top 10 and store them in 'fbx_blobs_10.txt'
# zcat /da?_data/basemaps/gz/b2fFullU*.s | fgrep .fbx | head -n 10 >> fbx_blobs_10.txt 
# #Go through the fbx_blobs_10.txt and use the first field which is the blobs to search for project names and store then in "fbx_projects_10.txt"
# cat fbx_blobs_10.txt |cut -d \; -f 1 | ~/lookup/getValues b2P >> fbx_projects_10.txt 
# #Go through the list of "blob;ProjectsNames" structure and extract the project names that is in a deforked group
# cat fbx_projects_10.txt | cut  -d";" -f2- >> fbx_project_10_fork.txt 
# #Select the original project name and keep the original
# cat fbx_project_10_fork.txt | cut -d ';' -f 1 >> fbx_project_10_single.txt 
# #Make sure there is no duplicat in the project names
# sort -u fbx_project_10_single.txt -o fbx_project_10_single_no_dup.txt 


# Attemp to store the value of blob to File name into a SQlite database in da4
# Takes too long to complete

# zcat /da?_data/basemaps/gz/b2fFullU*.s | fgrep .fbx | while IFS=";" read -r blob filename; do
#     safe_filename=$(echo "$filename" | sed "s/'/''/g")
#     sqlite3 /home/zguo20/WoC-Unity-Collect/my_database.db <<EOF
#     INSERT INTO fbx_blob_fname (blob_id, filename) VALUES ('$blob', '$safe_filename');
# EOF
# done


#Change the search to ".asset" files
zcat /da?_data/basemaps/gz/b2fFullU*.s | grep -iE "Assets/.+\.asset" >> asset_blobs_new.txt
grep -v "\.asset\.meta$" asset_blobs_new.txt > filtered_blobs.txt
cat filtered_blobs.txt |cut -d \; -f 1 | ~/lookup/getValues b2P >> asset_projects.txt
cat asset_projects.txt | cut  -d";" -f2- >> asset_project_defork.txt 
cat asset_project_defork.txt | cut -d ';' -f 1 >> asset_project_only.txt
sort -u asset_project_only.txt -o asset_project_only_no_dup.txt
