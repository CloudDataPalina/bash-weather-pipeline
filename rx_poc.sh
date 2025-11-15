#! /bin/bash

set -euo pipefail

city=Casablanca

curl -s "wttr.in/$city?T" --output weather_report

obs_temp=$(
  grep -m 1 -E '°|\?' weather_report \
  | grep -Eo -- '-?[0-9]+' \
  | head -1
)

echo "The current Temperature of $city: $obs_temp"

fc_temp=$(
  head -23 weather_report \
  | tail -1 \
  | grep -E '°|\?' \
  | grep -Eo -- '-?[0-9]+' \
  | head -1
)

echo "The forecasted temperature for noon tomorrow for $city : $fc_temp C"

TZ='Morocco/Casablanca'

day=$(TZ="$TZ" date -u +%d)
month=$(TZ="$TZ" date +%m)
year=$(TZ="$TZ" date +%Y)

record=$(printf "%s\t%s\t%s\t%s\t%s" "$year" "$month" "$day" "$obs_temp" "$fc_temp")

echo -e "$record" >> rx_poc.log
