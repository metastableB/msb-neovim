import os
import requests
import sys
import shutil
import stat

from src.utils import CLog as lg
from src.utils import git


class Config:
    # The latest stable/bleeding linux app image build. This will be downloaded
    # and used as neovim executable.
    NEOVIM_APPIMG = {
        'linux': "https://github.com/neovim/neovim/releases/download/v0.7.0/nvim.appimage",
        'osx': "https://github.com/neovim/neovim/releases/latest/download/nvim-macos.tar.gz",
    }
    # Platforms we have tested these scripts on.
    SUPPORTED_PLATFORMS = ["osx", 'linux']
    DOWNLOADS_DIR_NAME = 'downloads'
    LIB_DIR_NAME = 'lib'
    XDG_CONFIG_DIR_NAME = 'config'
    XDG_DATA_DIR_NAME = 'data' 
    RC_FILE_NAME = '.lmotiverc'
    # Git download links for various packages
    GH_NVCHAD = "https://github.com/NvChad/NvChad"
    GH_RIPGREP = {
        'osx': 'https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-apple-darwin.tar.gz',
        'linux': 'https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz',
    }
    GH_FD = {
        'osx': 'https://github.com/sharkdp/fd/releases/download/v8.3.0/fd-v8.3.0-x86_64-apple-darwin.tar.gz',
        'linux': 'https://github.com/sharkdp/fd/releases/download/v8.3.1/fd-v8.3.1-x86_64-unknown-linux-musl.tar.gz'
    }
    GH_TYPESHED = {
        'linux': "https://github.com/python/typeshed",
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
        f = os.path.join(install_dir, Config.XDG_CONFIG_DIR_NAME)
        self.xdg_config_dir = f
        f = os.path.join(install_dir, Config.XDG_DATA_DIR_NAME)
        self.xdg_data_dir = f
        # Absolute paths set during installation
        self.ap_nvim = None
        self.ap_ripgrep = None
        self.ap_fd = None


def setup_dirs(cfg):
    # Clean the base directory and setup downloads folder
    lg.info("STEP 1: Setting up installation directory and temporary " +
            "directories")
    lg.info(f"\tInstall directory: {cfg.install_dir}")
    lg.info(f"\tTemporary directory: {cfg.temp_dir}")
    msg = "The install directory should either be empty or should only contain"
    msg += f": '{cfg.LIB_DIR_NAME}', '{cfg.RC_FILE_NAME}', "
    msg += f" '{cfg.XDG_CONFIG_DIR_NAME}', '{cfg.XDG_DATA_DIR_NAME}'."
    # If install directory already exists do sanity checks.
    if os.path.exists(cfg.install_dir):
        lg.info("Existing install directory found")
        curr_files = os.listdir(cfg.install_dir)
        assert len(curr_files) <= 4, msg
        if len(curr_files) > 0:
            for f in curr_files:
                msg_ = msg + f" Found: {f}"
                valid = [cfg.LIB_DIR_NAME, cfg.RC_FILE_NAME,
                         cfg.XDG_CONFIG_DIR_NAME, cfg.XDG_DATA_DIR_NAME]
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
            os.mkdir(cfg.xdg_config_dir)
        except Exception as e:
            msg_ = "Exception raised when trying to create config directory: "
            msg_ += f"{cfg.xdg_config_dir}. Exception: "
            lg.fail(msg_ + e)
        try:
            os.mkdir(cfg.xdg_data_dir)
        except Exception as e:
            msg_ = "Exception raised when trying to create data directory: "
            msg_ += f"{cfg.xdg_data_dir}. Exception: "
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
    msg = f"Platform not tested/valid: {cfg.platform}"
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
        lg.info(f"Downloaded to {foutf}")
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
                lg.warning("Keeping it.")
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
    elif cfg.platform == 'linux':
        # For linux we get a .appimge. We just have to copy it to the right
        # place and set its permissions
        lg.info(f"Linux: Copying neovim.appimage to '{cfg.LIB_DIR_NAME}' " +
                "directory.")
        dst = os.path.join(cfg.lib_dir, 'nvim-linux64')
        if os.path.exists(dst):
            lg.warning("Linux: Library already contains an neovim folder.")
            lg.warning(dst)
            if overwrite:
                lg.warning("Linux: Removing it and replacing with new copy")
                shutil.rmtree(dst)
                assert not os.path.exists(dst)
            else:
                lg.warning("Linux: Keeping it.")
        if not os.path.exists(dst):
            os.makedirs(dst)
            shutil.copy(foutf, dst)
        exe = os.path.join(dst, 'nvim.appimage')
        assert os.path.exists(exe), f"Internal error. Not found {exe}"
        cfg.ap_nvim = os.path.abspath(exe)
        # Change permissions to executable
        lg.info("Linux: Making app image executable")
        st = os.stat(exe)
        os.chmod(exe, st.st_mode | stat.S_IEXEC) 
        lg.info("Linux: Nvim appimage setup done")

def setup_custom_config(cfg, overwrite=False):
    lg.info("Copying custom configuration")
    outf = os.path.join(cfg.xdg_config_dir, 'nvim/')
    lg.info("Copying custom configurations")
    if os.path.exists(outf):
        lg.warning("Existing custom settings found. Replacing it.")
        shutil.rmtree(outf)
    shutil.copytree('./nvimconfig/', outf)

def create_entry_script(cfg):
    rcfile = os.path.join(cfg.install_dir, cfg.RC_FILE_NAME)
    rcfile = os.path.abspath(rcfile)
    nvim = os.path.abspath(cfg.ap_nvim)
    xdgc = os.path.abspath(cfg.xdg_config_dir)
    xdgd = os.path.abspath(cfg.xdg_data_dir)
    template = f"""#!/bin/bash
function lmotive {{
  NVIM_EXE="{nvim}"
  NVIM_CONFIG_DIR="{xdgc}/nvim"
  NXDG_CONFIG_HOME="{xdgc}"
  NXDG_DATA_HOME="{xdgd}"
  env XDG_DATA_HOME="${{NXDG_DATA_HOME}}" XDG_CONFIG_HOME="${{NXDG_CONFIG_HOME}}" ${{NVIM_EXE}} "$@"
}}
"""
    # write to settings file
    with open(rcfile, 'w') as f:
        print(template, file=f)
    lg.info("1. Source the rcfile in your bashrc" + "\n" +
            f'\t\tsource "{rcfile}"')
    lg.info("2. Bootstrap packer and install plugins" + "\n" +
            "\t\tlmotive --headless -c 'autocmd User PackerComplete quitall'" +
            "-c 'PackerSync'")
    # lg.info("2. Install a patched nerd-font and set it as the font for you")
    # lg.info(" terminal emulator.")
    # msg = "3. Install the plugins by running:\n"
    # msg += "\tmnvim +'hi NormalFloat guibg=#1e222a' +PackerSync"
    # lg.info(msg)
    # if cfg.platform == 'osx':
    #     lg.info("NOTE: On mac, the terminal app does not support 24-bit " +
    #             "colors. iTerm is a good alternative.")

#
# def setup_ripgrep(cfg, overwrite=False):
#     lg.info("STEP 3: Setting up ripgrep executable")
#     outdir = cfg.downloads_dir
#     assert os.path.exists(outdir), "Download directory not found: " + outdir
#     # platform specify file names
#     url = cfg.GH_RIPGREP[cfg.platform]
#     outf = os.path.basename(url)
#     foutf = os.path.join(cfg.downloads_dir, outf)
#     msg = "Platform not tested/valid: {cfg.platform}"
#     assert cfg.platform in cfg.SUPPORTED_PLATFORMS, msg
#
#     if os.path.exists(foutf) and not overwrite:
#         msg = f"Reusing cached file: {foutf}"
#         lg.info(msg)
#     else:
#         lg.info("Downloading ripgrep.")
#         r = requests.get(url, allow_redirects=True)
#         if r.status_code != 200:
#             msg = f"Response error. Received status code: {r.status_code}"
#             lg.fail(msg)
#         with open(foutf, 'wb') as f:
#             f.write(r.content)
#         lg.info(f"Downloaded to {foutf}")
#     if cfg.platform == 'osx':
#         # For osX, we get a .tar.gz file. We need to extract it
#         lg.info(f"OSX: Extracting downloaded archive: {foutf}")
#         # We do not have control over the final folder that files will be
#         # extracted to. It depends on the name of the folder in the archive. We
#         # have thus hard-coded that here.
#         xdir_name = 'ripgrep-13.0.0-x86_64-apple-darwin'
#         osxoutf = os.path.join(cfg.downloads_dir, xdir_name)
#         if os.path.exists(osxoutf):
#             lg.warning(f"Found existing {osxoutf}.")
#             if overwrite:
#                 lg.warning(" Removing it.")
#                 shutil.rmtree(osxoutf)
#                 assert not os.path.exists(osxoutf)
#             else:
#                 lg.warning(" Keeping it.")
#         if not os.path.exists(osxoutf):
#             shutil.unpack_archive(foutf, cfg.downloads_dir)
#             assert os.path.exists(osxoutf)
#             lg.info(f"OSX: Extracted to: {osxoutf}")
#         lg.info(f"OSX: Copying extracted ripgrep to '{cfg.LIB_DIR_NAME}' " +
#                 "directory.")
#         dst = os.path.join(cfg.lib_dir, xdir_name)
#         if os.path.exists(dst):
#             lg.warning("Library already contains an extracted ripgrep folder.")
#             lg.warning(dst)
#             if overwrite:
#                 lg.warning("Removing it and replacing with new copy")
#                 shutil.rmtree(dst)
#                 assert not os.path.exists(dst)
#             else:
#                 lg.warning("Keeping it.")
#         if not os.path.exists(dst):
#             shutil.copytree(osxoutf, dst)
#         exe = os.path.join(dst, 'rg')
#         cfg.ap_ripgrep = os.path.abspath(exe)
#     elif cfg.platform == 'linux':
#         # For osX, we get a .tar.gz file. We need to extract it
#         lg.info(f"Linux: Extracting downloaded archive: {foutf}")
#         # We do not have control over the final folder that files will be
#         # extracted to. It depends on the name of the folder in the archive. We
#         # have thus hard-coded that here.
#         xdir_name = 'ripgrep-13.0.0-x86_64-unknown-linux-musl'
#         lnxoutf = os.path.join(cfg.downloads_dir, xdir_name)
#         if os.path.exists(lnxoutf):
#             lg.warning(f"Linux: Found existing {lnxoutf}.")
#             if overwrite:
#                 lg.warning("Linux: Removing it.")
#                 shutil.rmtree(lnxoutf)
#                 assert not os.path.exists(lnxoutf)
#             else:
#                 lg.warning(" Keeping it.")
#         if not os.path.exists(lnxoutf):
#             shutil.unpack_archive(foutf, cfg.downloads_dir)
#             assert os.path.exists(lnxoutf)
#             lg.info(f"Linux: Extracted to: {lnxoutf}")
#         lg.info(f"OSX: Copying extracted ripgrep to '{cfg.LIB_DIR_NAME}' " +
#                 "directory.")
#         dst = os.path.join(cfg.lib_dir, xdir_name)
#         if os.path.exists(dst):
#             lg.warning("Library already contains an extracted ripgrep folder.")
#             lg.warning(dst)
#             if overwrite:
#                 lg.warning("Removing it and replacing with new copy")
#                 shutil.rmtree(dst)
#                 assert not os.path.exists(dst)
#             else:
#                 lg.warning("Keeping it.")
#         if not os.path.exists(dst):
#             shutil.copytree(lnxoutf, dst)
#         exe = os.path.join(dst, 'rg')
#         cfg.ap_ripgrep = os.path.abspath(exe)
# # 
#
# def setup_fd(cfg, overwrite=False):
#     lg.info("STEP 4: Setting up fd (file search) executable")
#     outdir = cfg.downloads_dir
#     assert os.path.exists(outdir), "Download directory not found: " + outdir
#     # platform specify file names
#     url = cfg.GH_FD[cfg.platform]
#     outf = os.path.basename(url)
#     foutf = os.path.join(cfg.downloads_dir, outf)
#     msg = "Platform not tested/valid: {cfg.platform}"
#     assert cfg.platform in cfg.SUPPORTED_PLATFORMS, msg
#
#     if os.path.exists(foutf) and not overwrite:
#         msg = f"Reusing cached file: {foutf}"
#         lg.info(msg)
#     else:
#         lg.info("Downloading fd.")
#         r = requests.get(url, allow_redirects=True)
#         if r.status_code != 200:
#             msg = f"Response error. Received status code: {r.status_code}"
#             lg.fail(msg)
#         with open(foutf, 'wb') as f:
#             f.write(r.content)
#     if cfg.platform == 'osx':
#         # For osX, we get a .tar.gz file. We need to extract it
#         lg.info(f"OSX: Extracting downloaded archive: {foutf}")
#         # We do not have control over the final folder that files will be
#         # extracted to. It depends on the name of the folder in the archive. We
#         # have thus hard-coded that here.
#         xdir_name='fd-v8.3.0-x86_64-apple-darwin'
#         osxoutf = os.path.join(cfg.downloads_dir, xdir_name)
#         if os.path.exists(osxoutf):
#             lg.warning(f"Found existing {osxoutf}.")
#             if overwrite:
#                 lg.warning("Removing it.")
#                 shutil.rmtree(osxoutf)
#                 assert not os.path.exists(osxoutf)
#             else:
#                 lg.warning("Keeping it.")
#         if not os.path.exists(osxoutf):
#             shutil.unpack_archive(foutf, cfg.downloads_dir)
#             assert os.path.exists(osxoutf)
#             lg.info(f"OSX: Extracted to: {osxoutf}")
#         lg.info(f"OSX: Copying extracted neovim to '{cfg.LIB_DIR_NAME}' " +
#                 "directory.")
#         dst = os.path.join(cfg.lib_dir, xdir_name)
#         if os.path.exists(dst):
#             lg.warning("Library already contains an extracted fd folder.")
#             lg.warning(dst)
#             if overwrite:
#                 lg.warning("Removing it and replacing with new copy")
#                 shutil.rmtree(dst)
#                 assert not os.path.exists(dst)
#             else:
#                 lg.warning("Keeping it.")
#         if not os.path.exists(dst):
#             shutil.copytree(osxoutf, dst)
#         exe = os.path.join(dst, 'fd')
#         cfg.ap_fd = os.path.abspath(exe)
#     elif cfg.platform == 'linux':
#         # For osX, we get a .tar.gz file. We need to extract it
#         lg.info(f"Linux: Extracting downloaded archive: {foutf}")
#         # We do not have control over the final folder that files will be
#         # extracted to. It depends on the name of the folder in the archive. We
#         # have thus hard-coded that here.
#         xdir_name='fd-v8.3.1-x86_64-unknown-linux-musl'
#         lnxoutf = os.path.join(cfg.downloads_dir, xdir_name)
#         if os.path.exists(lnxoutf):
#             lg.warning(f"Linux: Found existing {lnxoutf}.")
#             if overwrite:
#                 lg.warning("Linux: Removing it.")
#                 shutil.rmtree(lnxoutf)
#                 assert not os.path.exists(lnxoutf)
#             else:
#                 lg.warning("Linux: Keeping it.")
#         if not os.path.exists(lnxoutf):
#             shutil.unpack_archive(foutf, cfg.downloads_dir)
#             assert os.path.exists(lnxoutf)
#             lg.info(f"Linux: Extracted to: {lnxoutf}")
#         lg.info(f"Linux: Copying extracted fd to '{cfg.LIB_DIR_NAME}' " +
#                 "directory.")
#         dst = os.path.join(cfg.lib_dir, xdir_name)
#         if os.path.exists(dst):
#             lg.warning("Library already contains an extracted fd folder.")
#             lg.warning(dst)
#             if overwrite:
#                 lg.warning("Removing it and replacing with new copy")
#                 shutil.rmtree(dst)
#                 assert not os.path.exists(dst)
#             else:
#                 lg.warning("Keeping it.")
#         if not os.path.exists(dst):
#             shutil.copytree(lnxoutf, dst)
#         exe = os.path.join(dst, 'fd')
#         cfg.ap_fd = os.path.abspath(exe)
#
#
# def setup_nvchad(cfg, overwrite=False):
#     lg.info("STEP 5: Setting up NvChad config")
#     url = cfg.GH_NVCHAD
#     outf = os.path.join(cfg.xdg_config_dir, 'nvim/')
#     if os.path.exists(outf):
#         lg.warning("Existing configuration found:", outf)
#         # This will also remove all plugin related settings
#         if overwrite:
#             lg.warning("Removing it")
#             shutil.rmtree(outf)
#             assert not os.path.exists(outf)
#     if not os.path.exists(outf):
#         git("clone", url, outf)
#     msg = "Internal error: NvChad not found after download"
#     assert os.path.exists(outf), msg
#     # Copy custom stuff
#     cdir = os.path.abspath(os.path.join(outf, 'lua/custom'))
#     lg.info("Copying custom configurations")
#     if os.path.exists(cdir):
#         lg.warning("Existing custom settings found. Replacing it.")
#         shutil.rmtree(cdir)
#     shutil.copytree('./custom', cdir)
#     cfg.ap_nvchad = os.path.abspath(outf)
#
# def setup_typeshed(cfg, overwrite=False):
#     lg.info("STEP 6: Typeshed (Python type stubs) ")
#     url = cfg.GH_TYPESHED['linux']
#     outf = os.path.join(cfg.lib_dir, 'typeshed')
#     if os.path.exists(outf):
#
#         lg.warning("Existing configuration found:", outf)
#         # This will also remove all plugin related settings
#         if overwrite:
#             lg.warning("Removing it")
#             shutil.rmtree(outf)
#             assert not os.path.exists(outf)
#     if not os.path.exists(outf):
#         git("clone", url, outf)
#     msg = "Internal error: Typeshed not found after download"
#     assert os.path.exists(outf), msg
#     # Copy custom stuff
#
# def post_install_msg(cfg):
#     lg.info("Post-installation instructions")
#     exe = cfg.ap_nvim
#     vimrc = cfg.ap_nvchad
#     ripgrep = os.path.dirname(cfg.ap_ripgrep)
#     fd = os.path.dirname(cfg.ap_fd)
#     msbrc = os.path.join(cfg.install_dir, cfg.RC_FILE_NAME)
#     msbrc = os.path.abspath(msbrc)
#     cdir = os.path.abspath(cfg.xdg_config_dir)
#     ddir = os.path.abspath(cfg.xdg_data_dir)
#     template = "#!/bin/bash\nfunction mnvim {"
#     template += f"""
#   NVIM_EXE="{exe}"
#   NVIM_CONFIG_DIR="{vimrc}"
#   NPATH=""" + '"${PATH}:' + f'{fd}:{ripgrep}"'
#     template += f"""
#   NXDG_CONFIG_HOME="{cdir}"
#   NXDG_DATA_HOME="{ddir}"
#   PYLSP_PATH="$(which pylsp)"
#   if [ ! -z "$PYLSP_PATH" ]
#   then
#     PYLSP=$(dirname $PYLSP_PATH)
#     NPATH="$NPATH:$PYLSP"
#   fi\n"""
#     template += 'env XDG_DATA_HOME="${NXDG_DATA_HOME}" '
#     template += 'XDG_CONFIG_HOME="${NXDG_CONFIG_HOME}" PATH="${NPATH}" '
#     template += '${NVIM_EXE} "$@"\n}'
#     # write to settings file
#     with open(msbrc, 'w') as f:
#         print(template, file=f)
#     lg.info("1. Source the `.msbrc` file in your bashrc" + "\n" +
#             f'\t\tsource "{msbrc}"')
#     lg.info("2. Install a patched nerd-font and set it as the font for you")
#     lg.info(" terminal emulator.")
#     msg = "3. Install the plugins by running:\n"
#     msg += "\tmnvim +'hi NormalFloat guibg=#1e222a' +PackerSync"
#     lg.info(msg)
#     if cfg.platform == 'osx':
#         lg.info("NOTE: On mac, the terminal app does not support 24-bit " +
#                 "colors. iTerm is a good alternative.")

