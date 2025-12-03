#!/usr/bin/env bash

declare -g debug

function setOptions {
	while getopts 'd' opt; do
		case "$opt" in
		d) debug=1 ;;
		*) debug=0 ;;
		esac
	done
}

function log {
	if [[ "$debug" == '1' ]]; then
		echo "$1"
	fi
}

function main {
	setOptions "$@"
	for item in $@; do
		if [[ -f "$item" ]]; then
			local inputFile="$item"
			break 2
		fi
	done
	local zeroCount=0
	local dial=50
	while IFS=$'\n' read -r line; do
		if [[ -z $line ]]; then
			continue
		fi
		log "cur  : $dial"

		#	local pos=(${line/\v(L|R)([0-9]+)/\1\ \2/})
		local pos=($(echo "$line" | sed -E 's/(L|R)([0-9]+)/\1 \2/'))
		log "input: ${pos[@]}"

		if [[ "${pos[0]}" == 'L' ]]; then
			local sign=-1
		elif [[ "${pos[0]}" == 'R' ]]; then
			local sign=1
		fi

		local rem=$((${pos[1]} % 100))
		((dial += rem * sign))
		log "adjus: $dial"
		if ((dial < 0)); then
			log "readj: 100 + $dial"
			((dial += 100))
		elif ((dial > 99)); then
			log "readj: $dial - 100"
			((dial -= 100))
		fi
		log "end  : $dial
"

		if ((dial == 0)); then
			((zeroCount += 1))
		fi
	done <$inputFile
	echo "$zeroCount"
}

main "$@"
