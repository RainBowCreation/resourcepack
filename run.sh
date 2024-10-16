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

CP() {
    mkdir -p $(dirname "$2") && cp -r "$1" "$2"
}
LI() {
    for F in "${@}"
    do
        echo "copying ${F}.."
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
        cp "${log_directory}" "${log_directory}".tmp
        sed '$ d' "${log_directory}".tmp > "${log_directory}"
        rm -f "${log_directory}".tmp
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
        echo "$1" >> "${log_directory}"
        cat "${log_directory}"
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

DEP() {
    if [ "${debug}" = true ]
    then
        read -p "Press enter to continue"
    fi
}

# Clear the tmp&target directory for the current version
rm -rf "$tmp_directory"
rm -rf "$target_directory"

# Create the target and temporary directories
mkdir -p "$target_directory"
mkdir -p "$tmp_directory"

# Loop through each supported version
for ((current_version=0; current_version<total_versions; current_version++)); do
    version=${support_versions[current_version]}
    source_directory="v1_$version"
    
    # Check if the source directory exists
    if [[ ! -d "$source_directory" ]]; then
        echo "Directory $source_directory does not exist. Skipping."
        continue
    fi

    # Count total files in the current version
    total_files=$(find "$source_directory" -type f | wc -l)
    current_file=0

    # Copy files from the source directory to the tmp directory
    for file in "$source_directory"/*; do
        filename=$(basename "$file")

        # If the filename starts with a "-", delete the corresponding file in tmp if it exists
        if [[ "$filename" == -* ]]; then
            target_file="$tmp_directory/${filename:1}"
            rm -f "$target_file"
        else
            # Otherwise, copy the file to tmp
            cp -r "$file" "$tmp_directory/"
        fi

        # Update file progress
        ((current_file++))
        progress_file=$((current_file * 100 / total_files))
        printf "\rProcessing files in v1_$version: [%-20s] %d%% of %d files" \
            "$(printf '#%.0s' $(seq 1 $((progress_file / 5))))" "$progress_file" "$total_files"
    done

    echo ""  # Move to the next line after file progress

    # Zip the contents of the tmp directory without including the tmp directory itself
    (cd "$tmp_directory" && zip -r "../$target_directory/${packname}_${prefix}${version}.zip" ./*)

    # Update overall progress
    progress_version=$((current_version + 1))
    progress_percentage=$((progress_version * 100 / total_versions))
    printf "\rCompressing v1_$version: [%-20s] %d%% of %d versions" \
        "$(printf '#%.0s' $(seq 1 $((progress_percentage / 5))))" "$progress_percentage" "$total_versions"

    echo ""  # Move to the next line after version progress
done

# Clean up the temporary directory
rm -rf "$tmp_directory"