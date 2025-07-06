# Bash Scripting for Sysadmin Automation

This Bash script automates the creation of a structured training environment for a batch of students. It sets up personalized directories, generates a `README.md` for each student, logs favorite Linux commands, and performs backup of user data.

## Features

- Interactive menu for setup and backup options
- Creates user-specific directories:
  - `Documents-<batch>`
  - `Projects-<batch>`
  - `Logs-<batch>`
  - `Backups-<batch>`
- Writes a custom `README.md` for each user's project folder
- Records each student's favorite Linux command
- Compresses and stores user environment backups
- Logs errors in `setup_errors.log`

##  Requirements

- Unix/Linux system
- Bash shell
- `tar` command for backups
- Sufficient permissions to access `/home/training`

##  Usage

### 1. Make the script executable

```bash
chmod +x setup_training_env.sh
```

### 2. Run the script

```bash
./setup_training_env.sh
```

### 3. Choose from the interactive menu

- **Option 1:** Run full setup for a batch of students
- **Option 2:** Perform a backup for a specific student
- **Option 3:** Exit the script

##  FiLe Structure

After running the setup, the following structure is created under `/home/training/<username>`:

```
/home/training/<username>/
├── Documents-<batch>
├── Projects-<batch>/
│   └── README.md
├── Logs-<batch>/
│   └── favcmds.txt
└── Backups-<batch>/
```

Backups are stored as `.tar.gz` archives in the local `./backups` directory.

## Example

During full setup:
- You’ll be asked to enter a batch name (e.g., `July2025`)
- Then enter student usernames separated by spaces
- Then enter each student's favorite Linux command (e.g., `htop`, `ls`, `grep`, etc.)

## Error Logging

All setup and backup errors are logged to:

```
setup_errors.log
```
