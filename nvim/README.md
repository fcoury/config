# NeoVim Config

## Cheat sheet

### vim-surround

`ys<motion><char>` surround
  `ysw'` -> 'word'
  `cs'"` -> "word"
  `ds"`  -> word

### ReplaceWithRegister

copy text and replace something else

  `te|xt1 text2`

  go to text1 and `yiw` -> copy text1
  go to next word with `w`
  replace text2 with copied `text1` with `grw`

  `text1 text1`

### Comment

```
 3 something
 2 something else
 1 third line
4  fourth line
```

  `gc3j`

```
 3 /* something */
 2 /* something else */
 1 /* third line */
4  /* fourth line */
```
  
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
