#!/usr/bin/env bash

function main {
	while getopts 'd' opt; do
		case "$opt" in
		d) local debug=1 ;;
		*) local debug=0 ;;
		esac
	done
	local inputFile="$1"
	local zeroCount=0
	local currentPosition=50
	while IFS=$'\n' read -r line; do
		if [[ -z $line ]]; then
			continue
		fi
		#	local pos=(${line/\v(L|R)([0-9]+)/\1\ \2/})
		if ((debug == 1)); then echo "cur  : $currentPosition"; fi

		local pos=($(echo "$line" | sed -E 's/(L|R)([0-9]+)/\1 \2/'))
		if ((debug == 1)); then echo "input: ${pos[@]}"; fi

		if [[ "${pos[0]}" == 'L' ]]; then
			local sign=-1
		elif [[ "${pos[0]}" == 'R' ]]; then
			local sign=1
		fi

		local rem=$((${pos[1]} % 100))
		((currentPosition += rem * sign))
		if ((debug == 1)); then echo "adjus: $currentPosition"; fi
		if ((currentPosition < 0)); then
			if ((debug == 1)); then echo "readj: 100 + $currentPosition"; fi
			((currentPosition += 100))
		elif ((currentPosition > 99)); then
			if ((debug == 1)); then echo "readj: $currentPosition - 100"; fi
			((currentPosition -= 100))
		fi
		if ((debug == 1)); then echo "end  : $currentPosition"; fi

		if ((currentPosition == 0)); then
			((zeroCount += 1))
		fi
	done <$inputFile
	echo "$zeroCount"
}

main "$@"
