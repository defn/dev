#!/bin/bash

kind=$1
shift
dir=$1
shift
num=$1
shift
base=$1
shift

newline=$'\n'

# Initialize an array with 12 zeros
for ((i = 0; i < num; i++)); do
	values[i]=0
done

# Function to find the index of the minimum value in the array
find_min_index() {
	local min_index=0
	local min_value=${values[0]}

	for ((i = 0; i < num; i++)); do
		if ((values[i] < min_value)); then
			min_value=${values[i]}
			min_index=$i
		fi
	done

	echo $min_index
}

echo '<!DOCTYPE html><head>'
echo '<link rel="stylesheet" href="/gallery.css">'
echo '</head>'

echo '<body style="background-color: black;">'
echo '<script src="/gallery.js"></script>'

# Start the HTML table
echo '<table><tbody id="table-body"><tr>'

echo "<script>"
echo "const basePath = '$dir';"
echo "var numColumns = $num;"
echo "const selectMode = '$kind';"

echo "const images = ["
# Read filenames from stdin
while read -r imgid; do
	if [[ ${kind} == yes ]]; then
		if test -r yes/${imgid}.png; then
			continue
		fi
		if test -r yes/${imgid}.jpeg; then
			continue
		fi
	fi
	height=$(echo "select thumb_height from img where id = '$imgid'" | sqlite3 cv.db)
	if [[ -z ${height} ]]; then height=300; fi

	echo "{ filename: \"$imgid.png\", width: 400, height: $height},"

done
echo "];"

echo "generateGrid();"
echo "</script>"

# End the HTML table
echo "</tr></tbody></table>"

echo '<div id="overlay"/><br>'
echo "</body></html>"
