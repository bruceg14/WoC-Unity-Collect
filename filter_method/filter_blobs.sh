#!/bin/bash

INPUT_FILE="practice"

OUTPUT_FILE="filtered_asset_blobs.txt"

> "$OUTPUT_FILE"

while IFS=';' read -r blob_id file_name; do

    if ~/lookup/showCnt blob <<< "$blob_id" | grep -Fq "VisualScripting"; then
        echo "Found 'VisualScripting' in $file_name"
        echo "$blob_id;$file_name" >> "$OUTPUT_FILE"      
    fi
done < "$INPUT_FILE"
echo "Filtered list of blobs saved to $OUTPUT_FILE."
