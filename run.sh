#!/bin/bash
filename="RainBowCreation"
prefix="v1_"
for V in 8 9 11 13 15 17 18 19 20
do
    file="${prefix}${V}"
    zipped="${filename}${file}.zip"
    echo "compressing ${file}..."
    zip $file $zipped
done
echo "done"