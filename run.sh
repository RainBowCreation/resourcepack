#!/bin/bash
filename="RainBowCreation"
dir="target"
lite="lite"
prefix="v1_"
support_versions=(8 9 11 13 15 17 18 19 20)
asset="assets"
minecraft="${asset}/minecraft"
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
    "${texture}/font"
)
list_19=(
    "${minecraft}/atlases"
    "${minecraft}/atlates"
)
CP() {
    mkdir -p $(dirname "$2") && cp -r "$1" "$2"
}
LI() {
    for F in "${@}"
    do
        # echo "copying ${F}.."
        CP  "${F}" "${lite}/${F}"
    done
}

total_versions=${#support_versions[@]}
current_version=0

rm -rf "${dir}"
mkdir "${dir}"

echo "running..."
for V in "${support_versions[@]}"
do 
    ((current_version++))
    progress="["
    for I in $(seq 1 ${total_versions})
    do
        if [ "${I}" -lt "${current_version}" ]
        then
            progress+="#"
        else
            progress+=" "
        fi
    done
    progress+="] (${current_version}/${total_versions})"
    echo -ne "${progress}\r"

    file="${prefix}${V}"
    # echo "compressing ${file}..."
    cd "${file}"
    # echo "create cache file for ${lite} version.."
    mkdir "${lite}"
    LI "${list[@]}"
    if [ "${V}" -gt 11 ]; then
        LI "${list_13[@]}"
    fi
    if [ "${V}" -gt 18 ]; then
        LI "${list_19[@]}"
    fi
    cd ${lite}
    zipped="${filename}_${file}"
    zip -qr "../../${dir}/${zipped}_${lite}.zip" *
    cd ..
    rm -rf "${lite}"
    # echo "compressing full version of ${file}.."
    zip -qr "../${dir}/${zipped}.zip" *
    cd ..
done
# echo "compressing bedrock version.."
cp "${filename}.mcpack" "${dir}/"
echo -ne "\n"
echo "done"