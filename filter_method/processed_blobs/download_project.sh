#!/bin/bash

# This file processed the blobs; filename, then organize it and output three files
# One for project name as a text file
# One for the project url as a csv file
# One is a text file in the format of blobs; filename; project url.
# Input file containing blob;filename pairs
input_file="blobs_with_first_4_section.txt"

# Output files
projects_file="unity_projects.txt"
final_output="blob_filename_project_mapping.txt"

# Step 1: Process input file and create temporary files
while IFS=';' read -r blob filename; do
    # Get project info for the blob using b2P
    project_info=$(echo "$blob" | ~/lookup/getValues b2P)
    
    if [ ! -z "$project_info" ]; then
        # Extract project name and combine with original blob and filename
        echo "$blob;$filename;$(echo $project_info | cut -d ';' -f2)" >> "$final_output"
    fi
done < "$input_file"

# Step 2: Create a sorted unique list of projects
cat "$final_output" | cut -d ';' -f3 | sort -u > "$projects_file"

# Step 3: Format the output file for readability
echo "Blob;Filename;Project" > formatted_output.txt
sort "$final_output" >> formatted_output.txt

awk -F ';' '{
  $3 = "github.com/" gensub("_", "/", "g", $3);
  print $1 ";" $2 ";" $3;
}' OFS=';' formatted_output.txt > updated_input_file.txt

awk -F ';' '{print $3}' formatted_output.txt | grep -v '^bitbucket' | sed 's/^/github.com\//; s/_/\//g' > github_projects.csv

