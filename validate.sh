#!/bin/bash
validator_directory="validator"
target_directory="target"
tmp_directory="tmp"
tmp_target="$tmp_directory/target"
tmp_validator="$tmp_directory/validator"
red='\031[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
nc='\033[0m'

# check if target & validator dir exists
if [[ ! -d "$target_directory"  ]]; then
    echo -e "${red}Target directorty not found, ${nc}please generate one using ${green}./run.sh ${nc}"
    exit 1
fi
if [[ ! -d "$validator_directory" ]]; then
    # validator directory not exists try make new one
    mkdir -p "$validator_directory"
fi

# check if zip file matched
compare_zip_contents() {
    local target_zip="$1"
    local validator_zip="$2"
    

    # clear tmp dir
    rm -rf "$tmp_directory"
    mkdir -p "$tmp_directory"
    # unzip target and validator file to tmp_dir
    unzip -q "$target_zip" -d "$tmp_target"
    unzip -q "$validator_zip" -d "$tmp_validator"

    # compare file
    target_files=($(find "$tmp_target" -type f  | sed "s|$tmp_target/||"))
    validator_files=($(find "$tmp_validator" -type f  | sed "s|$tmp_validator/||"))
    
    if [[ ${#target_files[@]} -ne ${#validator_files[@]} ]]; then
        echo -e "|  |_ ${red}Contens of $target_zip and $validator_zip do not matched in number of files.${nc}"
    fi
    for file in "${target_files[@]}"; do
        if [[ ! "${validator_files[@]}" =~ " ${file} " ]]; then
            echo -e "|  |_ Files ${red}$file ${nc}$target_zip is missing in $validator_zip."
        fi
    done
}

# check files contents
for target_zip in "$target_directory"/*.zip; do
    zip_name=$(basename "$target_zip")
    validator_zip="$validator_directory/$zip_name"

    if [[ -f "$validator_zip" ]]; then
        echo -e "| |_ Comparing $zip_name..."
        compare_zip_contents "$target_zip" "$validator_zip"
    else
        echo -e "| |_ Files ${red}$zip_name ${nc}not found in validator directory."
    fi
done

rm -rf "$tmp_directory"