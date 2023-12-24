#!/bin/bash
filename="RainBowCreation"
dir="target"
lite="lite"
prefix="v1_"
support_versions=(8 9 11 13 15 17 18 19 20)
rm -rf "${dir}"
mkdir "${dir}"
list=(
    "pack.mcmeta"
    "pack.png"
    "assets/minecraft/textures/gui/container/inventory.png"
    "assets/minecraft/textures/gui/title/minecraft.png"
    "assets/minecraft/textures/gui/title/edition.png"
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
    rm -rf "${lite}"
    echo "compressing full version of ${file}.."
    zip -qr "../${dir}/${zipped}.zip" *
    cd ..
done
echo "compressing bedrock version.."
cp "${filename}.mcpack" "${dir}/"
echo "done"