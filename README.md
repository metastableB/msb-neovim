# MSB-Neovim

Neovim + NvChad + custom configuraiton to make a portable, pre-compiled binary
dependent version of Neovim with good defaults. 

Supported platforms:

  - [X] OSX
  - [X] UNIX + Bash / WSL2
  - [ ] Windows + PS

# Installation

Clone this repository to your local machine. Open the folder in a terminal with
bash execute the following commands.

```
./setup.sh 
source ./.venv-nvim-setup/bin/activate
python3 install.py
```

For colored log outputs, set `CLOG_COLOR_ON=1`.

TODO: Wrap these into single `setup.sh` script.

## Post-Install Steps

We do not include any LSP servers and they need to be installed on a need
basis. We do include *nvim-lspconfig* plugin which is a collection of common
configuration for a variety of LSP servers. See the [LSP Plugins](#lsp-plugins)
section for more information on LSP and included plugins. 

[Here is a
list](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
of LSP servers whoes configuration we ship with (as part of *nvim-lspconfig*).
Install required LSP servers from here. 

# Usage Documentation

To see the current registered key-maps, use `<leader>ch`.

## (Self-contained) Plugin Notes

`NvChad` ships with a set of self-contained plugins that does not require any
external intervention or dependencies. These are a good set of defaults and
provide a good base set of settings for your working environment.

**1. Telescope (Fuzzy file, buffer, code, grep everything)**

Telescope is a blazigly fast (from experience) fuzzy finder. It can search is
all sorts of lists and can be configured to use all kinds of *finders, sorters*
and *pickers*. The defaults provided with NvChad is pretty sweet.

| Keybind      | Description                          |
|--------------|--------------------------------------|
| `<leader>fb` | Search in open buffers               |
| `<leader>ff` | Search in files in working direcotry |
| `<leader>fa` | Searchin hidden files                |
| `<leader>fh` | Search in neovim help-tags           |
| `<leader>fw` | Live grep search                     |
| `<leader>th` | Theme picker                         |

**2. Buffline (Buffer and minimal-Tab handling)**

Note that with the integration of bufferline, we are moving more towards the
vim style of workflow (fixed tab-window splits + buffer groups). This may need
some getting used to. 

Open buffers are shown from the left end and tabs are shown on the right side
of buffer line.

*Future*

- *Buffer Groups*: Buffline also supports buffer groups. This could be a
  better way to organize buffers. if the need be, check this out in the future.
- *Error Indicators*: Buffline also supports visual indicators for linting
  errors and such. This will be useful for `C/C++` or even large python
  projects; at a quick glance can give you info about faulty files etc.

**3. Nvim-Tree (File explorere side-bar)**

Tree based file explorer side-bar.

| Keybind | Description                               |
|---------|-------------------------------------------|
| `a`     | Append (add file/directory)               |
| `r`     | Rename file                               |
| `y`     | Copy name to system clipboard             |
| `Y`     | Copy relative path to system cliboard     |
| `gy`    | Copy absolute path to sysrtem clipboard   |
| `d`     | Delete file                               |
| `-`     | Go to parent direcoty of current path     |
| `s`     | Open file with default system application |
| `<C-v>` | Open file in a vertical split             |
| `<C-x>` | Open file in a horizontal spilt           |
| `<C-t>` | Open file in a new tab                    |
| `<Tab>` | Open file in preview                      |
| `I`     | Toggle visibility of hidden items         |
| `H`     | Toggle visibility of dot-items            |
| `R`     | Refresh tree                              |


**4. Others**

- *dashboard-nvim* (disabled): Provides an welcome dashboard with options to
  open existing files, previous sessions etc. Keeping it disabled for now
- *feline.nvim*: Statusline plugin with good defaults
- *blankline*: Adds indent lines to neovim indents
- *nvim-base16.lua*: Manages syntax colorscheme
- *nvim-colorizer.lua*: Colors inline hex codes and such
- *nvim-webdev-icons*: Allows changing color of icons.
- *gitsigns.nvim*: Super fast git decorations (the bars on the sides of files
  showng changes) implemented purely in lua/teal.
- *nvim-opairs*: Handle character pairs (braces, paraenthesis, ..)
- *vim-matchup*: Not entirely sure what the workflow/use-case is but this
  plugin makes it easy to navigate between langauge specific keywords (if-else
  blocks, whiel loops etc)
- *nvim-comment*: Toggles comments.
- *command-palette*: Custom command palette

## LSP Plugins

Requires installation of external programs. These are not shipped with this
package and the desired language support needs to be installed on a case to
case basis.

Neovim supports the Language Server Protocol (LSP), which means it acts as a
client to language servers and includes a Lua framework `vim.lsp` for building
enhanced LSP tools. LSP facilitates features like:

  - go-to-definition
  - find-references
  - hover
  - completion
  - rename
  - format
  - refactor

Neovim provides an interface for all of these features, and the language server
client is designed to be highly extensible to allow plugins to integrate
language server features which are not yet present in Neovim core such as
auto-completion (as opposed to manual completion with omnifunc) and snippet
integration.

Configuring LSP is not trivial though and does require some work, especially in
setting up language dependent LSP servers. Various plugins already included in
`NvChad` helps in this regard. These plugins still depend on external servers
being availabel.

- *nvim-lspconfig*: A collection of common configurations for Neovim's built-in
  language server client. This plugin allows for declaratively configuring,
  launching, and initializing language servers you have installed on your
  system.
- *nvim-cmp*: A completion engine plugin for neovim written in Lua. Completion
  sources are installed from external repositories and "sourced".
- *lsp-signature.nvim*: Show function signature when you type.
- *lspkind.nvim*: Adds pictograms to neovim built-in lsp completion items window.

# Install Explanations

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
  - *STEP 3* : Install `ripgrip` from precompiled binaries. This again goes
    into `$INSTALL_DIR/lib`
  - *STEP 4* : Install `fd` precompiled binaries. This again goes into
    `$INSTALL_DIR/lib`
  - *STEP 5* : Set up `NvChad`. NvChad is a set of minimal configuration files
    and plugins that we will use as our base configuration. The scripts are all
    written in Lua and supports easy customization. We clone `NvChad` to
    `$INSTALL_DIR/config/` which is where all our plugins will work from.


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
