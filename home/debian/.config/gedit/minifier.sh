#!/usr/bin/env sh
file_type() {
    list=$(find "./" -type f -name "*.min.$1" -not -name "all.min.$1")
    > "all.min.$1"
    for i in $list; do
        cat $i >> "all.min.$1"
    done
    echo "Output: "$(pwd)"/all.min.$1"
    echo "Output: "$(pwd)"/$filename.min.$1"
}
filepath=$GEDIT_CURRENT_DOCUMENT_DIR
filename="${GEDIT_CURRENT_DOCUMENT_NAME%.*}"
src_dir=${PWD##*/}
for path in "." ".." "../.." "../../.." "../../../.." "../../../../.."; do
    if [ -d "$path/dist" ]; then
        cd "$path/dist"
        src_dir=""
        break
    fi
done
if [ "$src_dir" = "src" ]; then
    cd ../
fi
if [ $1 = "css" ]; then
    if [ -d "./css" ]; then
        cd css
    fi
    curl -X POST -s --data-urlencode "input@$filepath/$filename.css" https://www.toptal.com/developers/cssminifier/api/raw > "$filename.min.css"
    file_type "css"
else
    if [ $1 = "scss" ]; then
        if [ -d "./css" ]; then
            cd css
        fi
        if [ $filename = "all" ]; then
            sass "$filepath/all.scss" "all.min.css" --style compressed
        else
            sass "$filepath/$filename.scss" "$filename.min.css" --sourcemap=none --style compressed
            file_type "css"
        fi
    else
        if [ $1 = "js" ]; then
            if [ -d "./js" ]; then
                cd js
            fi
            curl -X POST -s --data-urlencode "input@$filepath/$filename.js" https://www.toptal.com/developers/javascript-minifier/api/raw > "$filename.min.js"
            file_type "js"
        fi
    fi
fi
