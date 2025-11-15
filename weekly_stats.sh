#!/bin/bash
set -euo pipefail

# Get last 7 accuracy values (6th column) from the synthetic file
mapfile -t week_fc < <(tail -7 synthetic_historical_fc_accuracy.tsv | cut -f6)

# Validate: print raw values
echo "Raw accuracy values (last 7 days):"
for i in "${!week_fc[@]}"; do
    echo "${week_fc[i]}"
done

echo
echo "Absolute accuracy values:"
# Convert to absolute values
for i in "${!week_fc[@]}"; do
    if (( week_fc[i] < 0 )); then
        week_fc[i]=$(( -week_fc[i] ))
    fi
    echo "${week_fc[i]}"
done

# Initialize minimum and maximum with the first element
minimum=${week_fc[0]}
maximum=${week_fc[0]}

# Find min and max
for item in "${week_fc[@]}"; do
    if (( item < minimum )); then
        minimum=$item
    fi
    if (( item > maximum )); then
        maximum=$item
    fi
done

echo
echo "minimum absolute error = $minimum"
echo "maximum absolute error = $maximum"

# --- Write weekly summary to TSV ---
echo -e "metric\tvalue" > weekly_summary.tsv
echo -e "min_abs_error\t$minimum" >> weekly_summary.tsv
echo -e "max_abs_error\t$maximum" >> weekly_summary.tsv

echo
echo "weekly_summary.tsv has been created."
