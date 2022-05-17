#!/usr/bin/env python3
# Author: Don Dennis
#
# -- Locomotive Neovim Setup --
#
# Design Goals:
#   1. Running this script in an empty directory will install neovim and all
#   necessary dependencies into it.
#   2. This installation should be as portable as possible. Further, all
#   execution commands must be run from user-space, and all builds should be
#   contained within the build/install directory.
#   3. Choose, to a reasonable extent, what to install and what to ignore.
#
# Note that originally, this script was written in bash. With version 0.2, we
# have moved to python for ease of use.


from src import helpers
import os
from src.utils import CLog as lg

# The directory to install neovim to.
INSTALL_DIR = './.lmotive/'
TEMP_DIR = '/tmp/lmotive/'

cfg = helpers.Config(install_dir=INSTALL_DIR, temp_dir=TEMP_DIR)
# STEP 1: Setup the install directories and setup directories
helpers.setup_dirs(cfg)
# STEP 2: Setting up neovim appimage. The `nvim_exe_path` attribute of config
# is set with the executable path for neovim.
helpers.setup_neovim_appimg(cfg)
assert os.path.exists(cfg.ap_nvim)
helpers.create_entry_script(cfg)
# helpers.setup_ripgrep(cfg)
# assert os.path.exists(cfg.ap_ripgrep)
# helpers.setup_fd(cfg)
# assert os.path.exists(cfg.ap_fd)
# helpers.setup_nvchad(cfg)
# assert os.path.exists(cfg.ap_nvchad)
# helpers.setup_typeshed(cfg)
