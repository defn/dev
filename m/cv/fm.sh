#!/usr/bin/env bash

if [[ -z "${1:-}" ]]; then
  set -- meh
fi

export model="$1"; shift

# Generate gallery images if missing
find pub/W -maxdepth 1 -type f -name '*.png' | xargs -n1 basename | sort | while read -r a; do
	export a
  find pub -maxdepth 1 -type d -name 'w-*' | cut -d/ -f2 | sort | runmany 5 '
    b="${1%%/}"
    if ! test -f pub/$b/$b-$a; then
      echo "$b $a $(cog predict "$model" -i input_image=@pub/W/$a -i swap_image=@pub/$b.png -o pub/$b/$b-$a 2>&1 | grep -i output)"
    fi
  ' 
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
