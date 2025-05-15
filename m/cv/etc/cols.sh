#!/bin/bash

kind=$1
shift
dir=$1
shift
base=$1
shift

if [[ -n "${1:-}" ]]; then
	root=$1
	shift
else
	root=
fi

if [[ -n "${1:-}" ]]; then
	thumbsdir=$1
	shift
else
	thumbsdir=thumbs
fi

if [[ -n "${1:-}" ]]; then
	thumbsext=$1
	shift
else
	thumbsext=png
fi

newline=$'\n'

echo '<!DOCTYPE html><head>'
echo '<link rel="stylesheet" href="/gallery.css">'
echo '</head>'

echo '<body style="background-color: black;">'
echo '<script src="/blurmap.js"></script>'
echo '<script src="/gallery.js"></script>'

# Start the HTML table
echo '<table><tbody id="table-body"><tr>'

echo "<script>"
echo "const basePath = '$dir';"
echo "const selectMode = '$kind';"
echo "const thumbsDir = '$thumbsdir';"
echo "const thumbsExt= '$thumbsext';"

echo "const images = ["
# Read filenames from stdin
while read -r imgid; do
	if [[ ${kind} == yes ]]; then
		if ! test -s ${root}${thumbsdir}/${imgid}.${thumbsext}; then
			continue
		fi
		if ! test -s ${root}img/${imgid}.jpeg; then
			continue
		fi
		if test -r ${root}yes/${imgid}.jpeg; then
			continue
		fi
	fi
	echo "{ filename: \"$imgid.${thumbsext}\" },"

done
echo "];"

echo "generateGrid();"
echo "</script>"

# End the HTML table
echo "</tr></tbody></table>"

echo '<div id="overlay"/><br>'
echo "</body></html>"
