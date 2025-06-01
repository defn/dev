#!/usr/bin/env bash

export model="$1"; shift

# Generate gallery images if missing
for a in $(find pub -maxdepth 1 -type d -name 'w-*' | cut -d/ -f2 | sort); do
	export a
	runmany 4 '
    a="${a%%/}"
    if ! test -f pub/$a/$a-$1; then
      echo $1
      cog predict "$model" -i input_image=@pub/W/$1 -i swap_image=@pub/$a.png -o pub/$a/$a-$1
    fi
  ' $(find pub/W -maxdepth 1 -type f -name '*.png' | xargs -n1 basename | sort)
done

# Generate index.html for each gallery
for a in $(find pub -maxdepth 1 -type d -name 'w-*' | cut -d/ -f2 | sort); do
	(
		echo "<img width=400 src=\"../$a.png\"></img><br>"
		find pub/$a -maxdepth 1 -type f -name 'w-*.png' | sort | while read -r img; do
			echo "<img width=400 src=\"$(basename "$img")\"></img><br>"
		done
	) >pub/$a/index.html
done

# Generate unified gallery page
(
	echo "<table>"

	echo "<tr>"
	echo "<td></td>"
	find pub -maxdepth 1 -type f -name 'w-*.png' | sort | while read -r img; do
		echo "<td><img width=400 src=\"$(basename "$img")\"></td>"
	done
	echo "</tr>"

	for template in $(find pub/W -maxdepth 1 -type f -name '*.png' | xargs -n1 basename | sort); do
		echo "<tr>"
		echo "<td><img width=400 src=\"W/$template\"></img></td>"
		for g in $(find pub -maxdepth 1 -type d -name 'w-*' | cut -d/ -f2 | sort); do
			echo "<td><img width=400 src=\"$g/$g-$template\"></img></td>"
		done
		echo "</tr>"
	done

	echo "</table>"
) >pub/w.html
