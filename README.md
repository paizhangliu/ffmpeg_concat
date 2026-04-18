This script concats all mp4 video files in a specified folder to a mp4 file called "output.mp4" using *ffmpeg*. I use this script to concat video slices from my dash camera installed on my car.

**Usage:**

```
chmod +x concat.sh
./concat.sh [path_with_mp4_files]
```

You can simply drag the folder into terminal to acquire the path you need.

You can also run the script without supplying any argument. In this case, the script will concat videos from the current folder.

The script safely handles paths with whitespace and skips an existing `output.mp4` so repeated runs do not accidentally re-concat the previous result.

Input files are processed in natural sort order. This works well for sequential names such as:

```text
clip1.mp4
clip2.mp4
clip10.mp4
```

It also correctly handles timestamp-style dashcam names such as:

```text
20260413105139_0001.mp4
20260413105139_0002.mp4
20260413105140_0001.mp4
```

so files are concatenated in the expected chronological order. When multiple files share the same timestamp prefix, they are further ordered by the numeric suffix after the underscore.
