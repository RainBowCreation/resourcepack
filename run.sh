#!/bin/bash
debug=true
packname="RainBowCreation"
lite="lite"
prefix="v1_"
support_versions=(8 9 11 13 15 17 18 19 20)
target_directory="target"
tmp_directory="tmp"
log_directory="log"
asset="assets"
minecraft="${asset}/minecraft"
texture="${minecraft}/textures"
gui="${texture}/gui"
container="${gui}/container"
title="${gui}/title"
logo="pack.png"
list=(
    "pack.mcmeta"
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
total_versions=${#support_versions[@]}
current_version=0
rm -rf "$tmp_directory" >/dev/null 2>&1
rm -rf "$target_directory" >/dev/null 2>&1
mkdir -p "$target_directory" >/dev/null 2>&1
mkdir -p "$tmp_directory" >/dev/null 2>&1
current_version_progress=0

for ((current_version=0; current_version<total_versions; current_version++)); do
    version=${support_versions[current_version]}
    source_directory="v1_$version"
    if [[ ! -d "$source_directory" ]]; then
        echo "Directory $source_directory does not exist. Skipping."
        continue
    fi
    rm -rf "$tmp_directory/*" >/dev/null 2>&1
    total_files=$(find "$source_directory" -type f | wc -l)
    current_file=0
    current_file_progress=0
    for file in "$source_directory"/*; do
        filename=$(basename "$file")
        if [[ "$filename" == -* ]]; then
            target_file="$tmp_directory/${filename:1}"
            rm -f "$target_file" >/dev/null 2>&1
        else
            cp -r "$file" "$tmp_directory/" >/dev/null 2>&1
        fi
        file_progress=$(( (current_file + 1) * 100 / total_files))
        version_progress=$(( (current_version + 1) * 100 / total_versions ))
        if [[ $file_progress > $current_file_progress || $version_progress > $current_version_progress ]]; then
            printf "\rCompressing %s [%-20s] %d%% of %d files [%-20s]" \
                "${prefix}${version}" \
                "$(printf '#%.0s' $(seq 1 $((version_progress / 5))))$(printf ' %.0s' $(seq 1 $((20 - version_progress / 5))))" \
                "$file_progress" "$total_files" \
                "$(printf '#%.0s' $(seq 1 $((file_progress / 5))))$(printf ' %.0s' $(seq 1 $((20 - file_progress / 5))))"
            current_file_progress=$file_progress
            current_version_progress=$version_progress
        fi
        ((current_file++))
    done
    (cd "$tmp_directory" && zip -q -r "../$target_directory/${packname}_${prefix}${version}.zip" ./*)
    echo ""
done

rm -rf "$tmp_directory" >/dev/null 2>&1
echo "-----------------------------------------------------"
echo "All zip files created successfully."