# Neovim-MetastableB

The objective is to use learnings from `init.vim` version 0.1 and create a
portable neovim version with all features working. If possible, I also want to
learn Lua on the way and implement asserts to establish what is available and
what is unavailable.

# Explanation

1. `setup.sh`: The first script to run is the setup script `setup.sh`. Since we
   are aiming for a portable installation, most of our dependencies are
   downloaded manually -- as opposed to fetching them from a package manager.
   To facilitate downloads in our python based install script, we need certain
   packages like `requests`. Thus the setup scripts creates a temporary virtual
   environment and installs these required packages.

2. `install.sh`: This script downloads and installs various executables
   including neovim. The script is designed to work in various *STEPS* which
   perform a self contained isolated action.

  - *STEP 1* : We setup two top level directories. A temporary directory at
    `TEMP_DIR = /tmp/nvim-msb/` and the installation directory at
    `INSTALL_DIR=./.nvim-msb/`. Certain sub-directories are also created but
    those are entirely maintained internally.
  - *STEP 2* : Download neovim app-image. We download neovim to the
    installation directory; the correct version is downloaded based on platform
    details stored in `helper.Config`. We store this in `$INSTALL_DIR/lib` and
    use a `.msbrc` file make this availabel in path.
  - *STEP 3* : Install `ripgrip` from source. This again goes into
    `$INSTALL_DIR/lib`
  - *STEP 4* : Set up `NvChad`. NvChad is a set of minimal configuration files
    and plugins that we will use as our base configuration. The scripts are all
    written in Lua and supports easy customization. We clone `NvChad` to
    `$INSTALL_DIR/config/` which is where all our plugins will work from.




# Bugs, TODOs and Feature Requests

- [X] !BUG! The theme picker using telescope does not seem to work. When
  setting a theme, we seem to be encountering an error. 
  *Update* Seems to be an issue with upstream nvchad. It expects a `lua/custom`
  folder with `init.lua` and `chadrc`. Adding empty files fixed the bug.
  Upstream shoudl ideally use `perror()` when requiring these files.
- [ ] !BUG! Fix sidebard artifacts that shows up (next to line number) when
  working from within `tmux`
- [ ] Clean default settings and plugin configurations.
- [ ] Verify each and every existing (pre-packaged) plugin is working properly
- [ ] Configure packaged plugins.
- [ ] Start extending with more plugins
- [ ] Add a telescope list to search lablels and tags (`:TODO: :HELP:` etc)


# Usage Documentation

## Plugin Specific Notes

### Telescope (Fuzzy file, buffer, code, grep everything)

| Keybind      | Description                          |
|--------------|--------------------------------------|
| `<leader>fb` | Search in open buffers               |
| `<leader>ff` | Search in files in working direcotry |
| `<leader>fa` | Searchin hidden files                |
| `<leader>fh` | Search in neovim help-tags           |
| `<leader>fw` | Live grep search                     |
| `<leader>th` | Theme picker                         |

### Buffline (Buffer and minimal-Tab handling)

Note that with the integration of bufferline, we are moving more towards the
vim style of workflow (fixed tab-window splits + buffer groups). This may need
some getting used to. 

Open buffers are shown from the left end and tabs are shown on the right side
of buffer line.

**Future**

- **Buffer Groups**: Buffline also supports buffer groups. This could be a
  better way to organize buffers. if the need be, check this out in the future.
- **Error Indicators**: Buffline also supports visual indicators for linting
  errors and such. This will be useful for `C/C++` or even large python
  projects; at a quick glance can give you info about faulty files etc.


## Debugging

`:checkhealth` and `:checkhealth PLUGIN-NAME` is your best buds when trying to
debug things from within neovim. Also simple lua commands can be executed from
within neovim by prefixing the `lua` keyword. For instance, to view current
`rtp` you can type:

  `:lua print(vim.o.rtp)`

Note that due to Packer's lazy loading feature, most plugins won't be loaded 
till they are used for the first time. This means that a premature `checkhealth`
might fail. 

## Updating

We dont have a clean way to update all the installed dependencies. We use
github release URLs to download precompiled platform-dependent binaries. The
Github API does provide a way to automate this but there are dependency
considerations to be made. I dont want to reinvent a package manager so I'm
just going to stick to a stable version and only update occassionally.
