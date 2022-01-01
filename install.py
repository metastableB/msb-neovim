#!/usr/bin/env python3
# Author: Don Dennis
#
# -- Neovim Setup --
#
# Design Goals:
#   1. Running this script in an empty directory will install neovim and all
#   necessary dependencies into it.
#   2. This installation should be as portable as possible. Further, all
#   execution commands must be run from userspace.
#   3. Choose, to a reasonable extent, what to install and what to ignore.
#
# Note that originally, this script was written in bash. With version 0.2, we
# have moved to python for ease of use.

# -- 1. Assumptions --
#

from src import helpers
import os
from src.utils import CLog as lg

# -- 2. User Configuration --

# The directory to install neovim to.
INSTALL_DIR = './.neovim-msb/'
TEMP_DIR = '/tmp/neovim-msb/'

cfg = helpers.Config(install_dir=INSTALL_DIR, temp_dir=TEMP_DIR)
# STEP 1: Setup the install directories and setup directories
helpers.setup_dirs(cfg)
# STEP 2: Setting up neovim appimage. The `nvim_exe_path` attribute of config
# is set with the executable path for neovim.
helpers.setup_neovim_appimg(cfg)
assert os.path.exists(cfg.ap_nvim)
helpers.setup_ripgrep(cfg)
assert os.path.exists(cfg.ap_ripgrep)
helpers.setup_nvimchad(cfg)
assert os.path.exists(cfg.ap_nvchad)
helpers.post_install_msg(cfg)

#if false ; then
	#echo -e "${PRE_INFO} Installing global requirements"
	## ripgrep: Denite
	#install_global_rqs
	#if [ $? -ne 0 ]; then echo -e "${PRE_FAIL} Exiting"; exit 1; fi
	#echo -e "${PRE_INFO} Installing package manager: Vim-plug"
	#install_vimplug_reqs
	#if [ $? -ne 0 ]; then echo -e "${PRE_FAIL} Exiting"; exit 1; fi
	#echo -e "${PRE_INFO} Installing Requirements: Denite"
	#install_denite_reqs
	#if [ $? -ne 0 ]; then echo -e "${PRE_FAIL} Exiting"; exit 1; fi
	#echo -e "${PRE_INFO} Installing Requirements: ALE"
	#install_ale_reqs
#fi
## Edit init.vim.cpy and add extra configurations
#echo -e "${PRE_INFO} Configuring system python"
#SYS_PYTHON=$(which python3)
#cp "./init.vim" "./init.vim.cpy"
#if [ $? -ne 0 ]; then echo -e "${PRE_FAIL} Exiting"; exit 1; fi
#sed -i "s|g:python3_host_prog = .*$|g:python3_host_prog = \'${SYS_PYTHON}\'|" "./init.vim.cpy"
#if [ $? -ne 0 ]; then echo -e "${PRE_FAIL} Exiting"; exit 1; fi

## copy init.vim.cpy to right location
#DST="$HOME/.config/nvim/init.vim"
#echo -e "${PRE_INFO} Copying init.nvim to $DST"
#mkdir -p $HOME
#cp ./init.vim.cpy $DST
#if [ $? -ne 0 ]; then echo -e "${PRE_FAIL} Exiting"; exit 1; fi
## TODO: ENABLE THIS LATER rm ./init.vim.cpy
#rm "./init.vim.cpy"
## Open vim and run PlugInstall
#echo -e "${PRE_SUCC} Setup steps have been executed, check for errors."
#echo -e "${PRE_SUCC} If there  are none, then:"
#echo -e "${PRE_INFO} \t1. Add your local python binaries folder, usually"
#echo -e "${PRE_INFO} \t '~/.local/bin', to \$PATH."
#echo -e "${PRE_INFO} \t2. Check setting 3 of tmux.conf/neovim and see if"
#echo -e "${PRE_INFO} \t the $TERM value set is accurate."
#echo -e "${PRE_INFO} \t3. Your terminal needs to use a patched font for"
#echo -e "${PRE_INFO} \t  icones to work properly. Install a patched font"
#echo -e "${PRE_INFO} \t  For instance, source-code-pro Nerd Font"
#echo -e "${PRE_INFO} \t4. Run PlugInstall in neovim."
#echo -e "${PRE_INFO} \t5. Run :checkhealth in neovim."
