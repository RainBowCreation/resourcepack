#!/bin/bash
filename="RainBowCreation"
dir="target"
lite="lite"
prefix="v1_"
support_versions=(8 9 11 13 15 17 18 19 20)
rm -rf "${dir}"
mkdir "${dir}"
minecraft="assets/minecraft"
texture="${minecraft}/textures"
gui="${texture}/gui"
container="${gui}/container"
title="${gui}/title"
list=(
    "pack.mcmeta"
    "pack.png"
    "${container}/inventory.png"
    "${title}/minecraft.png"
    "${title}/edition.png"
)
list_13=(
    "${minecraft}/font"
    "${minecraft}/models/item"
    "${texture}/custom"
)
list_19=(
    "atlases"
    "atlates"
)
CP() {
    mkdir -p $(dirname "$2") && cp -r "$1" "$2"
}
LI() {
    for F in "${1[@]}"
        echo "copying ${F}.."
        CP  "${F}" "${lite}/${F}"
}
for V in "${support_versions[@]}"
do
    file="${prefix}${V}"
    echo "compressing ${file}..."
    cd "${file}"
    echo "create cache file for ${lite} version.."
    mkdir "${lite}"
    LI "${list}"
    if ${V} > 11
        LI "${list_13}"
    fi
    if ${V} > 18
        LI "${list_19}"
    fi
    echo "compressing ${lite} of ${file}.."
    cd "${lite}"
    zipped="${filename}_${file}"
    zip -qr "../../${dir}/${zipped}_${lite}.zip" *
    cd ..
    rm -rf "${lite}"
    echo "compressing full version of ${file}.."
    zip -qr "../${dir}/${zipped}.zip" *
done
echo "compressing bedrock version.."
cp "${filename}.mcpack" "${dir}/"
echo "done"