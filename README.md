This script concats all mp4 video files in a specified folder to a mp4 file called "output.mp4" using *ffmpeg*. I use this script to concat video slices from my dash camera installed on my car.

**Usage:**

```
chmod +x concat.sh
./concat.sh [path_with_mp4_files]
```

You can simply drag the folder into terminal to acquire the path you need.

You can also run the script without supplying any argument. In this case, the script will concat videos from the current folder.

**Warning:**

Path that contains whitespace or other funky characters will NOT WORK and might damage your data.

A workaround is to move this script inside the folder and run it without any argument.

*I accidentally permanently deleted a precious video file when writing this script.*
