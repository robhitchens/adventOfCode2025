#!/usr/bin/env bash

source bsunit-lib.sh

#SETUP
function setup {
	#set -x
	return 0
}

#TEARDOWN
function teardown {
	#set +x
	return 0
}

#TEST
function part1_test_usingExampleInput {
	# Assuming running at repo parent
	local output="$(./day1/solution.sh p1 ./day1/p1-example.txt)"

	assert "$output" equals "3"
}

#TEST
function part1_test_usingRealInput {
	# Assuming running at repo parent
	local output="$(./day1/solution.sh p1 ./day1/p1-input.txt)"

	assert "$output" equals "1118"
}

#TEST
function part2_test_usingExampleInput {
	# Assuming running at repo parent
	local output="$(./day1/solution.sh -d p2 ./day1/p1-example.txt)"

	assert "$output" equals "6"
}

#TEST
function part2_test_usingRealInput {
	# Assuming running at repo parent
	local output="$(./day1/solution.sh p2 ./day1/p1-input.txt)"

	# FIXME: figure out what the actual answer is.
	assert "$output" equals "3921"
}
