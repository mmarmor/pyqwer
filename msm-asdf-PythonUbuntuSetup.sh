#!/bin/bash
#
# Copyright (C) 2024 Michael Marmor | https://michaelmarmor.com/
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/.
#
# msm-asdf-PythonUbuntuSetup.sh | MSM 24-Jan-2024

# Summary:
#
# This bash script automates the process of updating the system,
# installing dependencies, and setting up Python development tools using
# asdf, python-launcher, and pipx. It performs several key tasks:
#
# 1. Updates and upgrades the system using APT.
# 2. Installs necessary dependencies for asdf, Python, and python-launcher.
# 3. Installs asdf from the specified git branch.
# 4. Executes a Python script to install the latest Python versions using asdf.
# 5. Installs python-launcher using cargo and updates the PATH.
# 6. Updates pip to the latest version and installs pipx globally.
# 7. Uses pipx to install essential Python development tools.
# 8. Lists available Python versions installed by asdf and python-launcher.
#
# Usage:
#
# Run this script to automatically update the system, install asdf,
# python-launcher, and set up a Python development environment. 
# Ensure 'msm-asdf-LatestPythonInstaller.py' is available and executable
# in the same directory as this script.
#
#---------------------------------------------------------------------------------
# Other notes:
#
# Full W11/WSL2 Ubuntu buildout using my two scripts:
#
# W11 admin cmd: wsl --install -d Ubuntu-22.04
#
# Use File Explorer to copy these two files into /home/marmor/ via the Ubuntu mount point
#
# msm-asdf-PythonUbuntuSetup.sh
# msm-asdf-LatestPythonInstaller.py
#
# marmor@MANTIS:~$ sudo chmod +x msm-asdf-PythonUbuntuSetup.sh msm-asdf-LatestPythonInstaller.py
#
# You must "source" the script instead of running it:
#
# source msm-asdf-PythonUbuntuSetup.sh
# # or
# . msm-asdf-PythonUbuntuSetup.sh
#
# marmor@MANTIS:~$ source msm-asdf-PythonUbuntuSetup.sh
#
# That should build the entire dev environment
#---------------------------------------------------------------------------------

# Function to log messages with a newline after each message
log_message() {
    local message=$1
    local color=$2
    echo -e "${color}${message}\e[0m\n"
}

# Color codes
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'

## General System Updates
log_message "Starting system update process..." "$GREEN"
sudo apt update
log_message "Upgrading APT packages..." "$GREEN"
sudo apt dist-upgrade -y
log_message "Removing unnecessary packages..." "$GREEN"
sudo apt autoremove -y
log_message "Cleaning up APT cache..." "$GREEN"
sudo apt autoclean
(command -v snap > /dev/null && log_message "Refreshing Snap packages..." "$GREEN" && sudo snap refresh) || echo "Snap not installed."
(command -v flatpak > /dev/null && log_message "Updating Flatpak packages..." "$GREEN" && flatpak update -y) || echo "Flatpak not installed."
log_message "System update process completed!" "$GREEN"

## Installing Dependencies for asdf and Python
log_message "Installing asdf and Python dependencies..." "$GREEN"
sudo apt install -y build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev cargo
log_message "Dependencies installation completed!" "$GREEN"

## Installing asdf
ASDF_VERSION="v0.14.0" # Check https://asdf-vm.com/guide/getting-started.html for the latest version
log_message "Installing asdf..." "$GREEN"
# Temporarily set advice.detachedHead to false for this operation
GIT_CONFIG_NO_DETACHED_ADVICE="git -c advice.detachedHead=false"
$GIT_CONFIG_NO_DETACHED_ADVICE clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "$ASDF_VERSION"
log_message "asdf installation completed!" "$GREEN"

## Updating bash PATH for asdf
log_message "Updating .bashrc for asdf..." "$GREEN"
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
log_message ".bashrc update for asdf completed!" "$GREEN"

## Installing Python Versions
log_message "Running Python script for installing Python versions in a subshell..." "$GREEN"
(
    source ~/.bashrc
    # Use python3 to run the script, as asdf-installed Python versions are not yet available
    python3 msm-asdf-LatestPythonInstaller.py
)
log_message "Python versions installation completed!" "$GREEN"

## Installing python-launcher
log_message "Installing python-launcher using cargo..." "$GREEN"
cargo install python-launcher
log_message "Updating .bashrc for python-launcher..." "$GREEN"
echo 'export PATH="$PATH:$HOME/.cargo/bin"' >> ~/.bashrc
source ~/.bashrc
log_message "Listing available Python versions..." "$GREEN"
py --list

## Upgrading pip and Installing pipx
source ~/.bashrc # Source .bashrc to make the asdf shims available
log_message "Upgrading pip and installing pipx..." "$GREEN"
# Now we use 'python' as it refers to the global version set by asdf
python -m pip install --upgrade pip
python -m pip install --user pipx
export PATH="$HOME/.local/bin:$PATH" # Add pipx's installation directory to PATH
log_message "Pip and pipx installation completed!" "$GREEN"

## Installing Global Python Tools with pipx
log_message "Installing Python tools with pipx..." "$GREEN"
pipx install build
pipx install tox
pipx install pre-commit
pipx install cookiecutter
log_message "Python tools installation completed!" "$GREEN"

log_message "MSM asdf python-launcher environment setup script completed." "$GREEN"
#log_message "To apply the changes made by this script to your current shell: source ~/.bashrc" "$GREEN"
#log_message "Or, for a complete refresh of the shell environment: exec \"$SHELL\"" "$GREEN"