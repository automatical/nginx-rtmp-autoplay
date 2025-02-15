#!/bin/bash

# Check if directory location and RTMP endpoint are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <directory_location> <rtmp_endpoint>"
    echo "--"
    echo "Example: ./stream.sh /data/raw_material rtmp:localhost:1935"
    exit 1
fi

DIRECTORY=$1
RTMP_ENDPOINT=$2
# Find all mp4 files in the directory tree
IFS=$'\n' MP4_FILES=($(find "$DIRECTORY" -type f -name "*.mp4"))
unset IFS
# Check if there are any mp4 files
if [ ${#MP4_FILES[@]} -eq 0 ]; then
    echo "No mp4 files found in the directory tree."
    exit 1
fi
# Randomly select an mp4 file and stream it to the RTMP endpoint
while true; do
    RANDOM_FILE="${MP4_FILES[RANDOM % ${#MP4_FILES[@]}]}"
    echo "$RANDOM_FILE"
    echo "Streaming $RANDOM_FILE to $RTMP_ENDPOINT"
    ffmpeg -re -i "$RANDOM_FILE" -c copy -f flv "$RTMP_ENDPOINT"
done
