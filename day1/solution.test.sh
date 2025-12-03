#!/usr/bin/env bash

source bsunit-lib.sh

#TEST
function part1_test_usingExampleInput {
	# Assuming running at repo parent
	local output="$(./day1/solution.sh ./day1/p1-example.txt)"

	assert "$output" equals "3"
}

#TEST
function part1_test_usingRealInput {
	# Assuming running at repo parent
	local output="$(./day1/solution.sh ./day1/p1-input.txt)"

	assert "$output" equals "1118"
}
