#!/bin/bash

INPUT_DIR="sorted_blobs"

OUTPUT_DIR="processed_blobs"

mkdir -p "$OUTPUT_DIR"

for input_file in "$INPUT_DIR"/*; do
    base_name=$(basename "$input_file")
    
    output_file="$OUTPUT_DIR/${base_name%.txt}_filtered.txt"

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

echo "All files processed. Results are in the '$OUTPUT_DIR' directory."
