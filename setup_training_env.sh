#!/bin/bash

# Trap Ctrl+C (SIGINT) to exit gracefully
trap "echo; echo 'Exiting by user request.'; exit 0" SIGINT

# Error log file path (cleared at start)
log_file="setup_errors.log"
: > "$log_file"

# Base directories for user training and backups
base_path="/home/training"
backup_path="./backups"

# Function: Create required directories for a user and batch
# Arguments:
#   $1 - user path
#   $2 - batch name

create_user_dirs() {
  local user_path="$1"
  local batch_name="$2"
  local dirs=("Documents-$batch_name" "Projects-$batch_name" "Logs-$batch_name" "Backups-$batch_name")

  for dir in "${dirs[@]}"; do
    local folder_path="$user_path/$dir"
    if [ -d "$folder_path" ]; then
      echo "Warning: $folder_path already exists." >> "$log_file"
    else
      mkdir -p "$folder_path"
      if [ $? -ne 0 ]; then
        echo "Error: Failed to create directory $folder_path" >> "$log_file"
      fi
    fi
  done
}

# Function: Write README.md file for a user project folder
# Arguments:
#   $1 - projects folder path
#   $2 - username
#   $3 - batch name

write_readme() {
  local projects_folder="$1"
  local username="$2"
  local batch_name="$3"
  local readme_file="$projects_folder/README.md"

  echo -e "Student Name: $username\nBatch Name: $batch_name\nDate of Setup: $(date '+%Y-%m-%d')" > "$readme_file"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to create README.md for $username" >> "$log_file"
  fi

  chmod 644 "$readme_file"
}

# Function: Backup user training directory
# Arguments:
#   $1 - username

backup_user_data() {
  local username="$1"
  local source_path="$base_path/$username"
  local timestamp
  timestamp=$(date '+%Y%m%d_%H%M%S')

  mkdir -p "$backup_path"
  if [ $? -ne 0 ]; then
    echo "Error: Could not create backup directory $backup_path" >> "$log_file"
    return 1
  fi

  if [ -d "$source_path" ]; then
    tar -czf "$backup_path/${username}_${timestamp}.tar.gz" "$source_path"
    if [ $? -ne 0 ]; then
      echo "Error: Backup failed for $username" >> "$log_file"
      return 1
    fi
    echo "Backup created for $username at $backup_path/${username}_${timestamp}.tar.gz"
  else
    echo "Error: Source directory '$source_path' does not exist, skipping backup." >> "$log_file"
    return 1
  fi
}

# Function: Run full setup for batch of students

full_setup() {
  # Prompt for batch name and usernames
  read -p "Enter the batch name: " batch_name
  batch_name="${batch_name// /}"  # Remove spaces

  read -p "Enter space-separated student usernames: " -a usernames

  local num_students=${#usernames[@]}
  echo "Batch '$batch_name' registered with $num_students students."

  # Loop through all usernames
  for username in "${usernames[@]}"; do
    local user_path="$base_path/$username"

    # Create directories
    create_user_dirs "$user_path" "$batch_name"

    # Write README.md
    local projects_folder="$user_path/Projects-$batch_name"
    write_readme "$projects_folder" "$username" "$batch_name"

    # Set permissions on directories
    chmod 755 "$user_path" \
      "$user_path/Documents-$batch_name" \
      "$projects_folder" \
      "$user_path/Logs-$batch_name" \
      "$user_path/Backups-$batch_name"

    # Prompt for favorite Linux command
    read -p "Enter favorite Linux command for $username: " fav_cmd

    # Save favorite command in Logs folder
    local logs_folder="$user_path/Logs-$batch_name"
    echo "$username: $fav_cmd" >> "$logs_folder/favcmds.txt"
    if [ $? -ne 0 ]; then
      echo "Error: Failed to write favcmds.txt for $username" >> "$log_file"
    fi

    # Backup user's environment
    backup_user_data "$username"

    echo "Environment setup for $username at $user_path"
  done
}


# Main interactive menu loop

while true; do
  echo "----------------------------------------"
  echo "Training Environment Setup Menu"
  echo "1) Run full setup"
  echo "2) Backup individual student"
  echo "3) Exit"
  echo "----------------------------------------"

  read -rp "Choose an option [1-3]: " choice

  case $choice in
    1)
      full_setup
      ;;
    2)
      read -rp "Enter the username to backup: " username
      backup_user_data "$username"
      ;;
    3)
      echo "Exiting... Goodbye!"
      exit 0
      ;;
    *)
      echo "Invalid option. Please enter 1, 2, or 3."
      ;;
  esac
done
