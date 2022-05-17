# Plugin and Configuration Documentation


## Basic Plugins

1. Packer
2. Nvim-tree
3. Telescope (Uses external executables that are installed by setup.sh)

## QoL Plugins
  - Buffline: Buffer and minimal-tab handling
  - Alpha.nvim: Dashboard
  - *feline.nvim*: Statusline plugin with good defaults
  - *blankline*: Adds indent lines to neovim indents
  - *nvim-webdev-icons*: Allows changing color of icons.
  - *gitsigns.nvim*: Super fast git decorations (the bars on the sides of files
      showing changes) implemented purely in lua/teal.


**LSP, Completion etc**
  - nvim-cmp
  - *nvim-lspconfig*: A collection of common configurations for Neovim's built-in
    language server client. This plugin allows for declaratively configuring,
    launching, and initializing language servers you have installed on your
    system.
  - *nvim-cmp*: A completion engine plugin for neovim written in Lua. Completion
    sources are installed from external repositories and "sourced".
  - *lsp-signature.nvim*: Show function signature when you type.
  - *lspkind.nvim*: Adds pictograms to neovim built-in lsp completion items window.



**QoL Plugins**

  - Vim-matchup
  - *nvim-base16.lua*: Manages syntax colorscheme
  - *nvim-colorizer.lua*: Colors inline hex codes and such
  - *nvim-opairs*: Handle character pairs (braces, parenthesis, ..)
  - *nvim-comment*: Toggles comments `<leader>/`
  - bufdelete
  - vim-python-pep8-indent
  - spellsitter
  - nvim-orgmode




# Plugin Documentation

We ship with a bunch of plugins already, and we install a few other through
packer. Some of these might require installing external dependencies likes LSP
servers. See details below.

## Telescope 

Telescope is a blazingly fast (from experience) fuzzy finder. It can search is
all sorts of lists and can be configured to use all kinds of *finders, sorters*
and *pickers*. The defaults provided with NvChad is pretty sweet. See
`custom-pallet` a plugin we made for telescope.

| Keybind      | Description                          |
|--------------|--------------------------------------|
| `<leader>fb` | Search in open buffers               |
| `<leader>ff` | Search in files in working direcotry |
| `<leader>fa` | Searchin hidden files                |
| `<leader>fh` | Search in neovim help-tags           |
| `<leader>fw` | Live grep search                     |
| `<leader>th` | Theme picker                         |
| `<leader>cp` | Custom palette                       |

## Custom-pallet

This is a configurable command pallet with fuzzy-search that I wrote. See
`custom/cpconfig.lua` on details on how to add more commands/scripts/details.
By default, bound to `<leader>cp`.

## Buffline (Buffer and minimal-Tab handling)

Note that with the integration of bufferline, we are moving more towards the
vim style of workflow (fixed tab-window splits + buffer groups). This may need
some getting used to. 

Open buffers are shown from the left end and tabs are shown on the right side
of buffer line.


## Nvim-Tree (File explorers side-bar)

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

## Vim-matchup 

This plugins allows for faster motion between the start, end and mid point of
standard programming constructs. For example, in an `if-elif-else` construct in
python say, we can move fast between all three blocks.

| Keybind | Description                                 |
|---------|---------------------------------------------|
|   `%`   | Go forward to next matching word            |
|   `[%`  | Go to previous outer open word              |
|   `]%`  | Go to the next surrounding close word       |
|   `z%`  | Go inside the nearest inner contained block |

There is more advanced stuff to be done but we will get there eventually.

## nvim-cmp

A completion engine plugin for neovim written in Lua. Completion sources are
installed from external repositories and "sourced". We use `luasnip` as our
snippet engine. Our sources are LSP, Lua and the buffer.

| Keybind        | Description                          |
|----------------|--------------------------------------|
|`C-p` or `S-Tab`| Cycle to previous                    |
| `C-n` or 'Tab' | Cycle to next                        |
| `C-d`   | Scroll down on docs                         |
| `C-f`   | Scroll forward on docs                      |
|`C-Space`| Complete                                    |
| `C-e`   | Close/exit                                  |
| `<CR>`  | Confirm                                     |
|  `[%`   | Go to previous outer open word              |
|   `]%`  | Go to the next surrounding close word       |
|   `z%`  | Go inside the nearest inner contained block |

## LSP plugin

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
integration. We ship with the *nvim-lspconfig* plugin which includes good
defaults for a lot of language servers. Just making sure they are installed and
checking that they are loaded through `:LspInfo` on the right file type should
be a good start.

- *nvim-lspconfig*: A collection of common configurations for Neovim's built-in
  language server client. This plugin allows for declaratively configuring,
  launching, and initializing language servers you have installed on your
  system.
- *nvim-cmp*: A completion engine plugin for neovim written in Lua. Completion
  sources are installed from external repositories and "sourced".
- *lsp-signature.nvim*: Show function signature when you type.
- *lspkind.nvim*: Adds pictograms to neovim built-in lsp completion items window.


## QoL Plugins

- *dashboard-nvim* (disabled): Provides an welcome dashboard with options to
  open existing files, previous sessions etc. Keeping it disabled for now
- *feline.nvim*: Statusline plugin with good defaults
- *blankline*: Adds indent lines to neovim indents
- *nvim-base16.lua*: Manages syntax colorscheme
- *nvim-colorizer.lua*: Colors inline hex codes and such
- *nvim-webdev-icons*: Allows changing color of icons.
- *gitsigns.nvim*: Super fast git decorations (the bars on the sides of files
    showing changes) implemented purely in lua/teal.
- *nvim-opairs*: Handle character pairs (braces, parenthesis, ..)
- *nvim-comment*: Toggles comments `<leader>/`

## TODO:

bufdelete, vim-python-pep8-indent, spellsitter, nvim-orgmode

# Install Explanations

1. `setup.sh`: Since we are aiming for a portable installation, most of our
   dependencies are downloaded manually -- as opposed to fetching them from a
   package manager. To facilitate downloads in our python based install script,
   we need `requests` package. The setup script creates a temporary virtual
   environment and installs `requests` for `python3` into it.

2. `install.sh`: This script downloads and installs various executable
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
just going to stick to a stable version and only update occasionally.
