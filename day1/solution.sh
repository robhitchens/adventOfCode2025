#!/usr/bin/env bash

declare -g debug=0 p1=0 p2=0

function setOptions {
	while getopts 'd' opt; do
		case "$opt" in
		d) debug=1 ;;
		esac
	done
	for flag in $@; do
		case ${flag/-/} in
		p1) p1=1 ;;
		p2) p2=1 ;;
		esac
	done
}

function log {
	if ((debug == 1)); then
		echo "$1" >&2
	fi
}

function setupInitialState {
	for item in $@; do
		if [[ -f "$item" ]]; then
			local inputFile="$item"
			break 2
		fi
	done
	echo "$inputFile 0 50"
}

function part1 {
	local state=($(setupInitialState "$@"))
	local inputFile="${state[0]}"
	local zeroCount="${state[1]}"
	local dial="${state[2]}"
	while IFS=$'\n' read -r line; do
		if [[ -z $line ]]; then
			continue
		fi
		log "cur  : $dial"
		if [[ $line =~ (L|R)([0-9]+) ]]; then
			local pos=(${BASH_REMATCH[@]:1})
			log "pos v: ${pos[@]}"
		else
			log "$line didn't match expression"
		fi
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

function part2 {
	local state=($(setupInitialState "$@"))
	local inputFile="${state[0]}"
	local zeroCount="${state[1]}"
	local dial="${state[2]}"
	while IFS=$'\n' read -r line; do
		if [[ -z $line ]]; then
			continue
		fi
		log "cur  : $dial"
		if [[ $line =~ (L|R)([0-9]+) ]]; then
			local pos=(${BASH_REMATCH[@]:1})
			log "pos v: ${pos[@]}"
		else
			log "$line didn't match expression"
		fi
		log "input: ${pos[@]}"

		if [[ "${pos[0]}" == 'L' ]]; then
			local sign=-1
		elif [[ "${pos[0]}" == 'R' ]]; then
			local sign=1
		fi

		local rem=$((${pos[1]} % 100))
		local div=$((${pos[1]} / 100))
		local additionalClicks=0
		((dial += rem * sign))
		log "adjus: $dial"
		if ((dial < 0)); then
			log "readj: 100 + $dial"
			((dial += 100))
			((additionalClicks++))
		elif ((dial > 99)); then
			log "readj: $dial - 100"
			((dial -= 100))
			((additionalClicks++))
		fi
		if ((div > 0)); then
			((additionalClicks *= div))
		fi

		log "addCl: $additionalClicks"
		if ((additionalClicks > 0)); then
			((zeroCount += additionalClicks))
		fi
		log "end  : $dial
"

		if ((dial == 0)); then
			((zeroCount += 1))
		fi

	done <$inputFile
	echo "$zeroCount"
}

function main {
	setOptions "$@"
	if ((p1 == 1)); then
		part1 "$@"
	elif ((p2 == 1)); then
		part2 "$@"
	fi
}

main "$@"
