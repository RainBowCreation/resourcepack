#!/bin/bash
filename="RainBowCreation"
dir="target"
prefix="v1_"
mkdir $dir
for V in 8 9 11 13 15 17 18 19 20
do
    file="${prefix}${V}"
    zipped="${filename}_${file}.zip"
    echo "compressing ${file}..."
    cd ${file}
    zip -r "../${dir}/$zipped" *
    cd ..
done
echo "done"