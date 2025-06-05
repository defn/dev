#!/usr/bin/env bash

if [[ -z ${1-} ]]; then
	set -- meh
fi

export model="$1"
shift

function fm {
	(
		echo '{ "input": {'

		echo '"input_image": "data:image/jpeg;base64,'$(cat $1 | base64 -w 0)'",'
		echo '"swap_image": "data:image/jpeg;base64,'$(cat $2 | base64 -w 0)'"'

		echo '} }'
	) | curl -s -X POST -H "Content-Type: application/json" -d @- http://localhost:5000/predictions
}

function fmpost {
	fm "$1" "$2" | jq -r .output | cut -d, -f2- | base64 -d >"$3.tmp"
	if file "$3.tmp" | grep -q "JPEG image data"; then
		mv -v "$3.tmp" "$3"
	fi
}

export -f fm
export -f fmpost

function main {
	# Generate gallery images if missing
	find pub/W -maxdepth 1 -type f -name '*.png' | xargs -n1 basename | sort | while read -r a; do
		export a
		find pub/ -maxdepth 1 -type d -name 'w-*' | cut -d/ -f2 | sort | runmany 5 '
      b="${1%%/}"
      for n in 1 2 3; do
        if ! test -f pub/$b/$b-$a; then
          echo "$b $a $(fmpost pub/W/$a pub/$b.png pub/$b/$b-$a)"
        fi
      done
    '
	done
}

main "$@"
