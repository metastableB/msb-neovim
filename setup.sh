#!/bin/bash
VENV_NAME="./.venv-lmotive"

if [ -d "$VENV_NAME" ]; then
  echo "Virtual environment found: $VENV_NAME"
  echo "Will be reused. Delete the folder to create new one."
else
  echo -e "Creating virtual environment for installation"
  virtualenv -p python3 "$VENV_NAME"
  if [ $? -ne 0 ]; then 
      echo -e "Failed to create install environment. Existing";
      exit 1;
  fi
  source "$VENV_NAME/bin/activate"
  pip install requests
  echo -e "Done."
fi

function install {
  source "$VENV_NAME/bin/activate"
  python install.py
}

install

