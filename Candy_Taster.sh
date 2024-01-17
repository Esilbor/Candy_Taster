#!/bin/bash

# Path to the test_list.txt file
test_list_file="test_list.txt"

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

# Test counter
test_number=1

# Function to run a single test
run_test() {
	local command="$1"

	# Run the command in bash and capture the output
	local bash_output=$(bash -c "$command")

	# Run the command in your Minishell and capture the output
	local minishell_output=$(echo "$command" | ./minishell)

	# Extract the relevant part of the Minishell output
	local filtered_output=$(echo "$minishell_output" | sed -n '2p' | sed 's/^[0-9]*_Candy_\$hell> //')

	# Trim the outputs to avoid issues with trailing newlines
	bash_output=$(echo -n "$bash_output")
	filtered_output=$(echo -n "$filtered_output")

	# Check if Bash output is empty and mark as TO CHECK
	if [ -z "$bash_output" ]; then
		echo -e "${ORANGE}Test $test_number: $command (TO CHECK)${NC}"
	elif [ "$bash_output" = "$filtered_output" ]; then
		echo -e "${GREEN}Test $test_number: $command (PASSED)${NC}"
	else
		echo -e "${RED}Test $test_number: $command (FAILED)${NC}"
		echo "     Bash Output: |$bash_output|"
		echo "Minishell Output: |$filtered_output|"
	fi

	# Increment the test number
	test_number=$((test_number + 1))
}

# Read each command from the test_list.txt file and run the test
while IFS= read -r line
do
	run_test "$line"
done < "$test_list_file"
