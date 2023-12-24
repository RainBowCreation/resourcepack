#!/bin/bash
filename="RainBowCreation"
dir="target"
lite="lite"
prefix="v1_"
lobby="l"
support_versions=(8 9 11 13 15 17 18 19 20)
rm -rf "${dir}"
mkdir "${dir}"
gui="assets/minecraft/textures/gui"
container="${gui}/container"
title="${gui}/title"
list=(
    "pack.mcmeta"
    "pack.png"
    "${container}/inventory.png"
    "${title}/minecraft.png"
    "${title}/edition.png"
)
llist=(
    "${container}/generic_54"
)
CP() {
    mkdir -p $(dirname "$2") && cp -r "$1" "$2"
}
for V in "${support_versions[@]}"
do
    file="${prefix}${V}"
    echo "compressing ${file}..."
    cd "${file}"
    echo "create cache file for lite version.."
    mkdir "${lite}"
    for F in "${list[@]}"
    do
        echo "copying ${F}.."
        CP  "${F}" "${lite}/${F}"
    done
    echo "compressing ${lite} of ${file}.."
    cd "${lite}"
    zipped="${filename}_${file}"
    zip -qr "../../${dir}/${zipped}_${lite}.zip" *
    cd ..
    for L in "${llist[@]}"
    do
        echo "copying ${L}.."
        CP "${L}_${lobby}.png" "${lite}/${L}.png"
    done
    echo "compressing ${lobby}_${lite} of ${file}.."
    cd "${lite}"
    zip -qr "../../${dir}/${zipped}_${lobby}_${lite}.zip" *
    cd ..
    rm -rf "${lite}"
    echo "compressing full version of ${file}.."
    zip -qr "../${dir}/${zipped}.zip" *
    echo "compressing ${lobby} version of ${file}.."
    for L in "${llist[@]}"
    do
        mv "${L}.png" "${L}_t.png"
        mv "${L}_${lobby}.png" "${L}.png"
    done
    zip -qr "../${dir}/${zipped}_${lobby}.zip" *
    echo "clear tmp file.."
    for L in "${llist[@]}"
    do
        mv "${L}.png" "${L}_${lobby}.png"
        mv "${L}_t.png" "${L}.png"
    done
    cd ..
done
echo "compressing bedrock version.."
cp "${filename}.mcpack" "${dir}/"
echo "done"