#!/bin/bash
set -euo pipefail

# Write header to output TSV
echo -e "year\tmonth\tday\ttoday_temp\tyesterday_fc\taccuracy\taccuracy_range" \
  > historical_fc_accuracy_full.tsv

# Read rows from rx_poc.log, skipping header
mapfile -t ROWS < <(tail -n +2 rx_poc.log)

# Iterate over pairs: yesterday (prev) → today (curr)
for ((i=1; i<${#ROWS[@]}; i++)); do
    prev="${ROWS[i-1]}"
    curr="${ROWS[i]}"

    # Extract fields using awk
    p_fc=$(echo "$prev" | awk '{print $5}')
    c_year=$(echo "$curr" | awk '{print $1}')
    c_month=$(echo "$curr" | awk '{print $2}')
    c_day=$(echo "$curr" | awk '{print $3}')
    c_obs=$(echo "$curr" | awk '{print $4}')

    # Calculate accuracy (forecast minus actual temperature)
    accuracy=$(( p_fc - c_obs ))

    # Classify the accuracy quality
    if (( accuracy >= -1 && accuracy <= 1 )); then
        range="excellent"
    elif (( accuracy >= -2 && accuracy <= 2 )); then
        range="good"
    elif (( accuracy >= -3 && accuracy <= 3 )); then
        range="fair"
    else
        range="poor"
    fi

    # Write row to TSV
    printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
        "$c_year" "$c_month" "$c_day" "$c_obs" "$p_fc" "$accuracy" "$range" \
        >> historical_fc_accuracy_full.tsv
done
