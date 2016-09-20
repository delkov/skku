#!/bin/bash
# find /home/delkov/Documents/skku/MISC -type f -name '*.fits' -printf "python3 /home/delkov/Documents/skku/hit_finder/new '%f' 8" | sh


# find /home/delkov/Documents/skku/MISC -type f -name '*.fits' -echo "python3 '%h/%f' 8" | sh

# find /home/delkov/Documents/skku/MISC -type f -name '*.fits' -exec p {} \;


ls "$1"/*.fits -I '*f*' | xargs -n1 python3 /home/delkov/Documents/skku/hit_finder/new "$2"