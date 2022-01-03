# Neovim-MetastableB

The objective is to use learnings from `init.vim` version 0.1 and create a
portable neovim version with all features working. If possible, I also want to
learn Lua on the way and implement asserts to establish what is available and
what is unavailable.

# Explanation

1. `setup.sh`: The first script to run is the setup script `setup.sh`. Since we are
   aiming for a portable installation, most of our dependencies are downloaded
   manually -- as opposed to fetching them from a package manager. To
   facilitate downloads in our python based install script, we need certain
   packages like `requests`. Thus the setup scripts creates a temporary virtual
   environment and installs these required packages.

2. `install.sh`: This script downloads and installs various executables
   including neovim. The script is designed to work in various *STEPS* which
   perform a self contained isolated action.

  - *STEP 1* : We setup two top level directories. A temporary directory at
     `TEMP_DIR = /tmp/nvim-msb/` and the installation directory at
     `INSTALL_DIR=./.nvim-msb/`. Certain sub-directories are also created
     but those are entirely maintained internally.
  - *STEP 2* : Download neovim app-image. We download neovim to the
     installation directory; the correct version is downloaded based on
     platform details stored in `helper.Config`. We store this in
     `$INSTALL_DIR/lib` and use a `.msbrc` file make this availabel in path.
  - *STEP 3* : Install `ripgrip` from source. This again goes into
     `$INSTALL_DIR/lib`
  - *STEP 4* : Set up `NvChad`. NvChad is a set of minimal configuration files
     and plugins that we will use as our base configuration. The scripts are
     all written in Lua and supports easy customization. We clone `NvChad` to
     `$INSTALL_DIR/config/` which is where all our plugins will work from.


# Bugs and Things to Do 

- [ ] The theme picker using telescope does not seem to work. When setting a
  theme, we seem to be encountering an error.

# TODOs

- [ ] Clean default settings and plugin configurations.
- [ ] Verify each and every existing (pre-packaged) plugin is working properly
- [ ] Configure packaged plugins.
- [ ] Start extending with more plugins
