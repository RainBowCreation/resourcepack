#!/bin/bash
filename="RainBowCreation"
dir="target"
lite="lite"
prefix="v1_"
support_versions=(8 9 11 13 15 17 18 19 20)
tmp="tmp"
log="${dir}/log"

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
RML() {
    if [ "$#" -eq 0 ]
    then
        cp "$1" "$1".tmp
        sed '$ d' "$1".tmp > "$1"
        rm -f "$1".tmp
    else
        cp "${log}" "${log}".tmp
        sed '$ d' "${log}".tmp > "${log}"
        rm -f "${log}".tmp
    fi
}
PR() {
    clear
    if [ "$#" -eq 2 ]
    then
        echo "$1" >> "$2"
        cat "$2"
        echo "${t_progress}" 
    else
        echo "$1" >> "${log}"
        cat "${log}"
        echo "${t_progress}"
    fi
}

total_versions=${#support_versions[@]}
current_version=0
t_progress=''

PRO() {
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
    t_progress="${progress}"
}

clear
echo "running..."
echo "remove ${dir} dir."
rm -rf "${dir}"
echo "remove cache dir."
rm -rf "${tmp}"

mkdir "${dir}"
mkdir "${tmp}"

cd "${dir}"
touch "${log}"
cd ..

echo "starting compile..."
for V in "${support_versions[@]}"
do 
    PRO
    #
    # cp each version to tmp dir
    # dont remove old content inside tmp just cp files
    # if there already a file with the same name use new version instead of old content
    # if file/dir that need to cp starts with "-" remove old content of tmp with name = file/dir without "-"
    #
    file="${prefix}${V}"
    PR "compressing ${file}..."
    # cd "${file}"
    PR "create cache file for ${lite} version.."
    # mkdir "${lite}"
    # LI "${list[@]}"
    # if [ "${V}" -gt 11 ]; then
    #     LI "${list_13[@]}"
    # fi
    # if [ "${V}" -gt 18 ]; then
    #     LI "${list_19[@]}"
    # fi
    # cd ${lite}
    # zipped="${filename}_${file}"
    # zip -qr "../../${dir}/${zipped}_${lite}.zip" *
    # cd ..
    # rm -rf "${lite}"
    PR "compressing full version of ${file}.."
    # zip -qr "../${dir}/${zipped}.zip" *
    # cd ..
done
rm -rf "${tmp}"
PR "compressing bedrock version.."
# cp "${filename}.mcpack" "${dir}/"
PR "done"