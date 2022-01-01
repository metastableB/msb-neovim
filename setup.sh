#!/bin/bash
VENV_NAME="./.venv-nvim-setup"
echo -e "Creating virtual environment for installation"
python3 -m venv "$VENV_NAME"
if [ $? -ne 0 ]; then 
    echo -e "Failed to create install environment. Existing";
    exit 1;
fi
source "$VENV_NAME/bin/activate"
pip install requests

echo -e "Done."
echo -e "Before running install.py, please source the environment with"
echo -e "\tsource $VENV_NAME/bin/activate"
