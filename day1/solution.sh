#!/usr/bin/env bash

function mainog {
	local inputFile="$1"
	local zeroCount=0
	local currentPosition=50
	while IFS=$'\n' read -r line; do
		#	local pos=(${line/\v(L|R)([0-9]+)/\1\ \2/})
		local pos=($(echo "$line" | sed -E 's/(L|R)([0-9]+)/\1 \2/'))
		echo "input: ${pos[@]}"
		if [[ "${pos[0]}" == 'L' ]]; then
			echo "expr : $currentPosition - ${pos[1]}"
			((currentPosition = currentPosition - ${pos[1]}))
		elif [[ "${pos[0]}" == 'R' ]]; then
			echo "expr : $currentPosition + ${pos[1]}"
			((currentPosition = currentPosition + ${pos[1]}))
		fi

		echo "adjus: $currentPosition"
		local sub=$((currentPosition % 100))
		if ((currentPosition < 0)); then
			echo "readj: 100 + $sub"
			((currentPosition = 100 + sub))
		elif ((currentPosition > 99)); then
			echo "readj: $sub"
			((currentPosition = sub))
		fi
		echo "end  : $currentPosition"

		if ((currentPosition == 0)); then
			((zeroCount += 1))
		fi
	done <$inputFile
	echo "$zeroCount"
}

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
