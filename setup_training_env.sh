#!/bin/bash

# Prompt for batch name
read -p "Enter the batch name: " batch_name

# Prompt for usernames
read -p "Enter space-separated student usernames: " -a usernames

# Count number of students
num_students=${#usernames[@]}

# Confirmation message
echo "Batch '$batch_name' registered with $num_students students."
