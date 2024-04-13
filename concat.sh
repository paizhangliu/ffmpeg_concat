#!/bin/sh
# An script to concat mp4 videos using ffmpeg
# Used by myself to concat videos from dash cameras
# Argument: folder that contains mp4 videos
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg is not installed"
    exit 1
fi
source=$1
if [[ $# != 1 || ! -d $1 ]]; then
    echo "Invalid source folder, using files in the current folder"
    source="./"
fi
if [[ "$source" != */ ]]; then
    source=""$source"/"
fi
for f in ""$source""*.mp4""; do
    echo "file '$f'" >> ""$source"videos.txt";
done
ffmpeg -f concat -safe 0 -i ""$source"videos.txt" -c copy ""$source"output.mp4"
rm ""$source"videos.txt"
read -p "Do you want to delete source video files? [y/N] " -r resp
if [[ "$resp" =~ [Yy] ]]; then
    for f in ""$source""*.mp4""; do
        if [[ "$f" == ""$source"output.mp4" ]]; then continue; fi
        rm $f
    done
fi
