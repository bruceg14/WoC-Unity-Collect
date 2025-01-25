#!/bin/bash

INPUT="github_projects.csv"

OUTPUT_DIR="cloned_github"

USERNAME=""

PAT=""

mkdir -p "$OUTPUT_DIR"

while IFS= read -r url; do
    echo "Cloning repository: $url..."
    repo_name=$(basename "$url" .git)
    git clone "https://$USERNAME:$PAT@$url" "$OUTPUT_DIR/$repo_name" || echo "Failed to clone "https://$USERNAME:$PAT@$url""
done < "$INPUT"


