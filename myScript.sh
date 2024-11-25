#!/bin/bash
echo 'Script to get the first 10 Unity file with .fbx extension from World of Code with their project name as output'

zcat /da?_data/basemaps/gz/b2fFullU*.s | fgrep .fbx | head -n 10 | tee fbx_blobs_10.txt
cat fbx_blobs_10.txt |cut -d \; -f 1 | ~/lookup/getValues b2P | tee fbx_projects_10.txt
cat fbx_blobs_10.txt | cut  -d";" -f2- >> fbx_project_10_single.txt
sort -u fbx_project_10_single.txt -o fbx_project_10_single.txt

