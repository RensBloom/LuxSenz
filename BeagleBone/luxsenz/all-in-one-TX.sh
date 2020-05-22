#!/bin/bash
insmod vlc.ko tx=1 frq=50 # The transmission does not start after this step
echo 1 > /proc/vlc/tx
./read_data.sh      # The transmission starts after this step
