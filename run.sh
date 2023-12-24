#!/bin/bash
filename="RainBowCreation"
dir="target"
lite="lite"
prefix="v1_"
mkdir $dir
cd $dir
echo "clearing old version"
rm -rf *
cd ..
echo "compiling full version.."
for V in 8 9 11 13 15 17 18 19 20
do
    file="${prefix}${V}"
    zipped="${filename}_${file}.zip"
    echo "compressing ${file}..."
    cd ${file}
    zip -qr "../${dir}/$zipped" *
    cd ..
done
echo "done"
echo "compiling lite version"
cd $lite
for V in 8 9 11 13 15 17 18 19 20
do
    file="${prefix}${V}"
    zipped="${filename}_${file}_${lite}.zip"
    echo "compressing ${file}..."
    cd ${file}
    zip -qr "../../${dir}/$zipped" *
    cd ..
done
cd ..
echo "done :)