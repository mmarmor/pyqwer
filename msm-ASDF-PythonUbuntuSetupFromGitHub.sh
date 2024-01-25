#!/bin/bash

# Copyright (C) 2024 Michael Marmor | https://michaelmarmor.com/
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/.
#
# msm-ASDF-PythonUbuntuSetupFromGitHub.sh | MSM 24-Jan-2024


# To use this script:
# curl -sL https://raw.githubusercontent.com/mmarmor/msm-UbuntuPythonDevEnvBuilder/main/msm-PythonDevEnvSetupFromGitHub.sh | bash

# Define the GitHub repository and branch
REPO_URL="https://raw.githubusercontent.com/mmarmor/msm-UbuntuPythonDevEnvBuilder/main"

# Define the filenames
SETUP_SCRIPT="msm-asdf-PythonUbuntuSetup.sh"
INSTALLER_SCRIPT="msm-asdf-LatestPythonInstaller.py"

# Download the scripts
echo "Downloading $SETUP_SCRIPT..."
curl -sLO "$REPO_URL/$SETUP_SCRIPT"

echo "Downloading $INSTALLER_SCRIPT..."
curl -sLO "$REPO_URL/$INSTALLER_SCRIPT"

# Make scripts executable
chmod +x "$SETUP_SCRIPT" "$INSTALLER_SCRIPT"

# Run the setup script
echo "Running MSM asdf + python-launcher Dev Environment setup script..."
source "./$SETUP_SCRIPT"
