# This file clone the repository and then keep the .asset file that has been filtered
USERNAME="bruceg14"
PAT=""
INPUT_FILE="updated_input_file.txt"
OUTPUT_DIR="downloaded_files"

mkdir -p "$OUTPUT_DIR"

sanitize_repo_name() {
    echo "$1" | sed 's/[^a-zA-Z0-9._-]/_/g'
}

# Input file format is "blob;filename;repo_url"
while IFS=';' read -r blob filename repo_url; do

    repo_name=$(sanitize_repo_name "$(basename "$repo_url")")
    repo_dir="$OUTPUT_DIR/$repo_name"
    
    # Clone repository
    echo "Cloning repository: $repo_url..."
    if ! git clone "https://$USERNAME:$PAT@$repo_url" "$repo_dir"; then
        echo "Failed to clone https://$USERNAME:$PAT@$repo_url"
        continue
    fi
    
    file_dir="$OUTPUT_DIR/extracted_files"
    mkdir -p "$file_dir"
    
    # Check if specific file exist
    if [ -f "$repo_dir/$filename" ]; then
        base_filename=$(basename "$filename")
        # Copy it in the file_directory
        cp "$repo_dir/$filename" "$file_dir/${repo_name}_${base_filename}"
        echo "Successfully copied: $filename as ${repo_name}_${base_filename}"
    else
        echo "File not found: $filename in $repo_url"
    fi
    
    # Remove the repository after
    echo "Removing repository: $repo_dir"
    rm -rf "$repo_dir"
    
done < "$INPUT_FILE"

echo "Download process completed. Files are in $OUTPUT_DIR/extracted_files/"
