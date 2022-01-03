import os
import requests
import sys
import shutil

from src.utils import CLog as lg
from src.utils import git


class Config:
    # The latest stable/bleeding linux app image build. This will be downloaded
    # and used as neovim executable.
    NEOVIM_APPIMG = {
        'linux': "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage",
        'osx': "https://github.com/neovim/neovim/releases/latest/download/nvim-macos.tar.gz",
    }
    # Platforms we have tested these scripts on.
    SUPPORTED_PLATFORMS = ["osx"]
    DOWNLOADS_DIR_NAME = 'downloads'
    LIB_DIR_NAME = 'lib'
    CONFIG_DIR_NAME = 'config'
    RC_FILE_NAME = '.msbrc'
    # Git download links for various packages
    GH_NVCHAD = "https://github.com/NvChad/NvChad"
    GH_RIPGREP = {
        'osx': 'https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-apple-darwin.tar.gz'
    }

    def __set_platform(self):
        if sys.platform in ["linux", "linux2"]:
            ret = "linux"
        elif sys.platform == "darwin":
            ret = "osx"
        elif sys.platform == "win32":
            ret = "win32"
        return ret

    def __init__(self, install_dir, temp_dir):
        self.install_dir = install_dir
        self.temp_dir = temp_dir
        self.platform = self.__set_platform()
        f = os.path.join(temp_dir, Config.DOWNLOADS_DIR_NAME)
        self.downloads_dir = f
        f = os.path.join(install_dir, Config.LIB_DIR_NAME)
        self.lib_dir = f
        f = os.path.join(install_dir, Config.CONFIG_DIR_NAME)
        self.config_dir = f
        # Absolute paths set during installation
        self.ap_nvim = None
        self.ap_nvchad = None
        self.ap_ripgrep = None


def setup_dirs(cfg):
    # Clean the base directory and setup downloads folder
    lg.info("STEP 1: Setting up installation directory and temporary " +
            "directories")
    lg.info(f"\tInstall directory: {cfg.install_dir}")
    lg.info(f"\tTemporary directory: {cfg.temp_dir}")
    msg = "The install directory should either be empty or should only contain"
    msg += f": '{cfg.LIB_DIR_NAME}', '{cfg.RC_FILE_NAME}', "
    msg += f" '{cfg.CONFIG_DIR_NAME}'"
    # If install directory already exists do sanity checks.
    if os.path.exists(cfg.install_dir):
        lg.info("Existing install directory found")
        curr_files = os.listdir(cfg.install_dir)
        assert len(curr_files) <= 3, msg
        if len(curr_files) > 0:
            for f in curr_files:
                msg_ = msg + f" Found: {f}"
                valid = [cfg.LIB_DIR_NAME, cfg.RC_FILE_NAME,
                         cfg.CONFIG_DIR_NAME]
                assert f in valid, msg_
    else:
        try:
            os.mkdir(cfg.install_dir)
        except Exception as e:
            msg_ = "Exception raised when trying to create install directory: "
            msg_ += f"{cfg.install_dir}. Exception: "
            lg.fail(msg_ + e)
        try:
            os.mkdir(cfg.lib_dir)
        except Exception as e:
            msg_ = "Exception raised when trying to create lib directory: "
            msg_ += f"{cfg.lib_dir}. Exception: "
            lg.fail(msg_ + e)
        try:
            os.mkdir(cfg.config_dir)
        except Exception as e:
            msg_ = "Exception raised when trying to create config directory: "
            msg_ += f"{cfg.config_dir}. Exception: "
            lg.fail(msg_ + e)
    # Install directory created. Now create temporary directory if it doesn't
    # exist.
    if not os.path.exists(cfg.temp_dir):
        try:
            os.mkdir(cfg.temp_dir)
        except Exception as e:
            msg_ = "Exception raised when trying to create temp directory: "
            msg_ += f"{cfg.temp_dir}. Exception: "
            lg.fail(msg_ + e)
        try:
            os.mkdir(cfg.downloads_dir)
        except Exception as e:
            msg_ = "Exception raised when trying to create download directory:"
            msg_ += f" {cfg.download_dir}. Exception: "
            lg.fail(msg_ + e)
    assert os.path.exists(cfg.downloads_dir)
    assert os.path.exists(cfg.lib_dir)
    assert os.path.exists(cfg.temp_dir)
    assert os.path.exists(cfg.install_dir)
    lg.info("Done")


def setup_neovim_appimg(cfg, overwrite=False):
    lg.info("STEP 2: Setting up neovim executable.")
    outdir = cfg.downloads_dir
    assert os.path.exists(outdir), "Download directory not found: " + outdir
    # platform specify file names
    url = cfg.NEOVIM_APPIMG[cfg.platform]
    outf = os.path.basename(url)
    foutf = os.path.join(cfg.downloads_dir, outf)
    msg = "Platform not tested/valid: {cfg.platform}"
    assert cfg.platform in cfg.SUPPORTED_PLATFORMS, msg

    if os.path.exists(foutf) and not overwrite:
        msg = f"Reusing cached file: {foutf}"
        lg.info(msg)
    else:
        lg.info("Downloading neovim release.")
        r = requests.get(url, allow_redirects=True)
        if r.status_code != 200:
            msg = f"Response error. Received status code: {r.status_code}"
            lg.fail(msg)
        with open(foutf, 'wb') as f:
            f.write(r.content)
    if cfg.platform == 'osx':
        # For osX, we get a .tar.gz file. We need to extract it
        lg.info(f"OSX: Extracting downloaded archive: {foutf}")
        # We do not have control over the final folder that files will be
        # extracted to. It depends on the name of the folder in the archive. We
        # have thus hard-coded that here.
        osxoutf = os.path.join(cfg.downloads_dir, 'nvim-osx64')
        if os.path.exists(osxoutf):
            lg.warning(f"Found existing {osxoutf}.")
            if overwrite:
                lg.warning(" Removing it.")
                shutil.rmtree(osxoutf)
                assert not os.path.exists(osxoutf)
            else:
                lg.warning(" Keeping it.")
        if not os.path.exists(osxoutf):
            shutil.unpack_archive(foutf, cfg.downloads_dir)
            assert os.path.exists(osxoutf)
            lg.info(f"Extracted to: {osxoutf}")
        lg.info(f"OSX: Copying extracted neovim to '{cfg.LIB_DIR_NAME}' " +
                "directory.")
        dst = os.path.join(cfg.lib_dir, 'nvim-osx64')
        if os.path.exists(dst):
            lg.warning("Library already contains an extracted neovim folder.")
            lg.warning(dst)
            if overwrite:
                lg.warning("Removing it and replacing with new copy")
                shutil.rmtree(dst)
                assert not os.path.exists(dst)
            else:
                lg.warning("Keeping it.")
        if not os.path.exists(dst):
            shutil.copytree(osxoutf, dst)
        exe = os.path.join(dst, 'bin/nvim')
        cfg.ap_nvim = os.path.abspath(exe)


def setup_ripgrep(cfg, overwrite=False):
    lg.info("STEP 3: Setting up ripgrep executable")
    outdir = cfg.downloads_dir
    assert os.path.exists(outdir), "Download directory not found: " + outdir
    # platform specify file names
    url = cfg.GH_RIPGREP[cfg.platform]
    outf = os.path.basename(url)
    foutf = os.path.join(cfg.downloads_dir, outf)
    msg = "Platform not tested/valid: {cfg.platform}"
    assert cfg.platform in cfg.SUPPORTED_PLATFORMS, msg

    if os.path.exists(foutf) and not overwrite:
        msg = f"Reusing cached file: {foutf}"
        lg.info(msg)
    else:
        lg.info("Downloading ripgrep.")
        r = requests.get(url, allow_redirects=True)
        if r.status_code != 200:
            msg = f"Response error. Received status code: {r.status_code}"
            lg.fail(msg)
        with open(foutf, 'wb') as f:
            f.write(r.content)
    if cfg.platform == 'osx':
        # For osX, we get a .tar.gz file. We need to extract it
        lg.info(f"OSX: Extracting downloaded archive: {foutf}")
        # We do not have control over the final folder that files will be
        # extracted to. It depends on the name of the folder in the archive. We
        # have thus hard-coded that here.
        xdir_name = 'ripgrep-13.0.0-x86_64-apple-darwin'
        osxoutf = os.path.join(cfg.downloads_dir, xdir_name)
        if os.path.exists(osxoutf):
            lg.warning(f"Found existing {osxoutf}.", end='')
            if overwrite:
                lg.warning(" Removing it.")
                shutil.rmtree(osxoutf)
                assert not os.path.exists(osxoutf)
            else:
                lg.warning(" Keeping it.")
        if not os.path.exists(osxoutf):
            shutil.unpack_archive(foutf, cfg.downloads_dir)
            assert os.path.exists(osxoutf)
            lg.info(f"OSX: Extracted to: {osxoutf}")
        lg.info(f"OSX: Copying extracted neovim to '{cfg.LIB_DIR_NAME}' " +
                "directory.")
        dst = os.path.join(cfg.lib_dir, xdir_name)
        if os.path.exists(dst):
            lg.warning("Library already contains an extracted ripgrip folder.")
            lg.warning(dst)
            if overwrite:
                lg.warning("Removing it and replacing with new copy")
                shutil.rmtree(dst)
                assert not os.path.exists(dst)
            else:
                lg.warning("Keeping it.")
        if not os.path.exists(dst):
            shutil.copytree(osxoutf, dst)
        exe = os.path.join(dst, 'rg')
        cfg.ap_ripgrep = os.path.abspath(exe)


def setup_nvchad(cfg, overwrite=False):
    lg.info("STEP 3: Setting up NvChad config")
    url = cfg.GH_NVCHAD
    outf = os.path.join(cfg.config_dir, 'nvim/nvchad')
    if os.path.exists(outf):
        lg.warning("Existing NvChad found")
        if overwrite:
            lg.warning("Removing it")
            shutil.rmtree(outf)
            assert not os.path.exists(outf)
    if not os.path.exists(outf):
        git("clone", url, outf)
    msg = "Internal error: NvChad not found after download"
    assert os.path.exists(outf), msg
    # Copy custom stuff
    cdir = os.path.join(outf, 'lua/custom')
    shutil.copytree('./custom', cdir)
    cfg.ap_nvchad = os.path.abspath(outf)

def post_install_msg(cfg):
    lg.info("Post-installation instructions")
    exe = cfg.ap_nvim
    vimrc = cfg.ap_nvchad
    ripgrep = os.path.dirname(cfg.ap_ripgrep)
    msbrc = os.path.join(cfg.install_dir, cfg.RC_FILE_NAME)
    msbrc = os.path.abspath(msbrc)
    cdir = os.path.abspath(cfg.config_dir)
    # These lines are fed to a shell-profile file (msbrc.sh) and the user is
    # expected to source them from their bashrc or equivalent profile file.
    # Settings to make neovim available globally
    scmds = f"NVIM_EXE='{exe}'" + "\n"
    scmds += f"NVIM_CONFIG_DIR='{vimrc}'" + "\n"
    # RIP-GREP
    scmds += 'NPATH=${PATH}:' + f"'{ripgrep}'"
    # Neovim and Lua config
    scmds += '\nNLUA_PATH="${LUA_PATH};${NVIM_CONFIG_DIR}/lua/?.lua;'
    scmds += '${NVIM_CONFIG_DIR}/lua/?/init.lua"'
    scmds += f"\nNXDG_CONFIG_HOME='{cdir}'"
    scmds += f"\nNXDG_DATA_HOME='{cdir}'"
    scmds += "\n" + 'alias msbnvim="env XDG_DATA_HOME=\\"'
    scmds += '${NXDG_DATA_HOME}\\" XDG_CONFIG_HOME=\\"${NXDG_CONFIG_HOME}\\"'
    scmds += ' LUA_PATH=\\"${NLUA_PATH}\\" PATH=\\"${NPATH}\\" \\"${NVIM_EXE}\\"   -u '
    scmds += '\\"${NVIM_CONFIG_DIR}' + '/init.lua\\""'
    scmds += '\necho "Sourced nvim configs"'

    # write to settings file
    with open(msbrc, 'w') as f:
        print(scmds, file=f)
    lg.info("1. Source the `msbrc.sh` file in your bashrc" + "\n" +
            f'\t\tsource "{msbrc}"')
    lg.info("2. Install a patched nerd-font and set it as the font for you")
    lg.info(" terminal emulator.")
    msg = "3. Install the plugins by running:\n"
    msg += "\tmsbnvim +'hi NormalFloat guibg=#1e222a' +PackerSync"
    lg.info(msg)
    if cfg.platform == 'osx':
        lg.info("NOTE: On mac, the terminal app does not support 24-bit " +
                "colors. iTerm is a good alternative.")

