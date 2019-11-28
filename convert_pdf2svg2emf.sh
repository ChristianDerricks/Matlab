#!/bin/bash
# convert every pdf in this folder to svg and emf

echo ""
for f in *.pdf 
do
    [ -e "$f" ] || continue
    echo "converting $f to emf"
    filename=$(basename -- "$f")
    extension="${filename##*.}"
    filename="${filename%.*}"
    pdf2svg "$filename.pdf" "$filename.svg"
    inkscape -T "$filename.svg" --export-emf="$filename.emf"   
done
echo ""
echo "done"
