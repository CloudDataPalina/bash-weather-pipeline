#!/bin/bash
set -euo pipefail

# Directory where backups will be stored
backup_dir="backups"
mkdir -p "$backup_dir"

timestamp=$(date +"%Y%m%d_%H%M%S")

# Files to include in the backup
files_to_backup=(
  "rx_poc.log"
  "historical_fc_accuracy_full.tsv"
  "weekly_summary.tsv"
)

# Filter only the files that actually exist
existing_files=()
for f in "${files_to_backup[@]}"; do
  if [[ -f "$f" ]]; then
    existing_files+=("$f")
  fi
done

if (( ${#existing_files[@]} == 0 )); then
  echo "No files found to back up."
  exit 0
fi

archive="$backup_dir/data_backup_${timestamp}.tar.gz"

tar -czf "$archive" "${existing_files[@]}"

echo "Backup created: $archive"
