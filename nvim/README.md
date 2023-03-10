# NeoVim Config

## Prerequisites

### Install Packer

```
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

The after starting neovim:

```
:PackerCompile
:PackerInstall
```

### Install and configure coc.vim

```
:CocInstall
:CocInstall coc-rust-analyzer
```

## Install Copilot

Copilot requires nodejs 16 or 17, so let's install [rtx](https://github.com/jdxcode/rtx):

```
curl https://rtx.pub/install.sh | sh
```

```
:Copilot setup
```
