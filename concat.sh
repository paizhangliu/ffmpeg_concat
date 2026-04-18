#!/bin/sh
# Concatenate MP4 videos in a folder into output.mp4 using ffmpeg.

set -eu

if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "ffmpeg is not installed"
    exit 1
fi

source_dir="${1:-.}"

if [ "$#" -gt 1 ]; then
    echo "Usage: $0 [path_with_mp4_files]"
    exit 1
fi

if [ ! -d "$source_dir" ]; then
    echo "Invalid source folder, using files in the current folder"
    source_dir="."
fi

source_dir=$(cd "$source_dir" && pwd)
output_file="$source_dir/output.mp4"
list_file=$(mktemp "${TMPDIR:-/tmp}/ffmpeg-concat.XXXXXX")

cleanup() {
    rm -f "$list_file"
}

trap cleanup EXIT INT TERM HUP

list_mp4_files() {
    if command -v python3 >/dev/null 2>&1; then
        find "$source_dir" -maxdepth 1 -type f \( -iname '*.mp4' \) ! -name 'output.mp4' | python3 -c '
import re
import sys

def natural_key(path):
    return [int(part) if part.isdigit() else part.lower() for part in re.split(r"(\d+)", path)]

for path in sorted((line.rstrip("\n") for line in sys.stdin), key=natural_key):
    print(path)
'
    else
        find "$source_dir" -maxdepth 1 -type f \( -iname '*.mp4' \) ! -name 'output.mp4' | sort
    fi
}

list_mp4_files | while IFS= read -r file; do
    escaped_file=$(printf "%s" "$file" | sed "s/'/'\\\\''/g")
    printf "file '%s'\n" "$escaped_file" >> "$list_file"
done

if [ ! -s "$list_file" ]; then
    echo "No MP4 files found in $source_dir"
    exit 1
fi

ffmpeg -f concat -safe 0 -i "$list_file" -c copy "$output_file"

printf "Do you want to delete source video files? [y/N] "
IFS= read -r resp

case "$resp" in
    [Yy]|[Yy][Ee][Ss])
        find "$source_dir" -maxdepth 1 -type f \( -iname '*.mp4' \) ! -name 'output.mp4' | while IFS= read -r file; do
            rm -f "$file"
        done
        ;;
esac
