# MSB-Neovim

My neovim configurations files and installation scripts for OSX and UNIX/
Bash-WSL2. 

# Installation

Clone this repository to your local machine. Open the folder in a terminal with
bash execute the following commands.

```
./setup.sh  
source ./.venv-nvim-setup/bin/activate
python3 install.py
```

The `setup.sh` script will create a virtual-environment in the package
directory. After sourcing this with the second command, the install script in
the third command will setup neovim and configurations to run out of this
directory. 

## Post-Install Notes

1. `.msbrc`: Follow the post install instructions in the `install.py` script to
    source `.msbrc`. This will make msb-neovim available from other locations.
2. `LSP Servers`: We do not include any LSP servers and they need to be
   installed on a need basis. We do include *nvim-lspconfig* plugin which is a
   collection of common configuration for a variety of LSP servers. [Here is a
   list](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
   of LSP servers whose configuration we ship with.

## Debugging

`:checkhealth` and `:checkhealth PLUGIN-NAME` is your best buds when trying to
debug things from within neovim. Also simple lua commands can be executed from
within neovim by prefixing the `lua` keyword. For instance, to view current
`rtp` you can type:

  `:lua print(vim.o.rtp)`

Note that due to Packer's lazy loading feature, most plugins won't be loaded 
till they are used for the first time. This means that a premature `checkhealth`
might fail. 
