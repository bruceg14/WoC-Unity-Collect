#!/bin/bash

#New script
zcat /da?_data/basemaps/gz/b2fFullU*.s | fgrep .asset | awk '/\.asset$/ {print}' > new_asset_blobs.txt

#Call organize_blobs.sh
INPUT="new_asset_blobs.txt"
OUTPUT_FILE="new_asset_blobs_no_dup.txt"
OUTPUT_DIR="filter_method/sorted_blobs"

mkdir -p "$OUTPUT_DIR"

sort -t ';' -k1,1 -u $INPUT -o $OUTPUT_FILE
split -n l/35 -d -a 2 $OUTPUT_FILE $OUTPUT_DIR/sorted_blobs_part_

#Filter blobs and store them in processed_blobs/processed_blobs/ directory
cd filter_method/

INPUT_DIR_1="sorted_blobs"
OUTPUT_DIR_1="processed_blobs"

mkdir -p "$OUTPUT_DIR_1"

for input_file in "$INPUT_DIR_1"/*; do
    base_name=$(basename "$input_file")

    output_file="$OUTPUT_DIR_1/${base_name%.txt}_filtered.txt"

    > "$output_file"
    echo "Processing file: $input_file"

    while IFS=';' read -r blob_id file_name; do
        if ~/lookup/showCnt blob <<< "$blob_id" | grep -Fq "VisualScripting"; then
            echo "    Found 'VisualScripting' in $file_name"
            echo "$blob_id;$file_name" >> "$output_file"
        fi
    done < "$input_file"

    echo "Results saved to: $output_file"
done

echo "All files processed. Results are in the '$OUTPUT_DIR_1' directory."





