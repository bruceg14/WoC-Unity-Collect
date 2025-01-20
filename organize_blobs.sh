#!/bin/bash

INPUT="new_asset_blobs.txt"
OUTPUT_FILE="new_asset_blobs_no_dup.txt"
OUTPUT_DIR="filter_method/sorted_blobs"

mkdir -p "$OUTPUT_DIR"

sort -t ';' -k1,1 -u $INPUT -o $OUTPUT_FILE
split -n l/35 -d -a 2 $OUTPUT_FILE $OUTPUT_DIR/sorted_blobs_part_
