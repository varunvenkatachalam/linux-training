#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
output_file="output.txt"

> "$output_file"

frame_time=""
wlan_type=""
wlan_subtype=""

while IFS= read -r line
do
    if echo "$line" | grep -q '"frame.time"'; then
        frame_time=$(echo "$line" | cut -d':' -f2- | sed 's/^[[:space:]]*//')
    fi

    if echo "$line" | grep -q '"wlan.fc.type"'; then
        wlan_type=$(echo "$line" | cut -d':' -f2- | sed 's/^[[:space:]]*//')
    fi

    if echo "$line" | grep -q '"wlan.fc.subtype"'; then
        wlan_subtype=$(echo "$line" | cut -d':' -f2- | sed 's/^[[:space:]]*//')
    fi

    if [ -n "$frame_time" ] && [ -n "$wlan_type" ] && [ -n "$wlan_subtype" ]; then
        {
            echo "\"frame.time\": $frame_time"
            echo "\"wlan.fc.type\": $wlan_type"
            echo "\"wlan.fc.subtype\": $wlan_subtype"
            echo ""
        } >> "$output_file"

        frame_time=""
        wlan_type=""
        wlan_subtype=""
    fi

done < "$input_file"

echo "Extraction completed. Output saved in $output_file"
