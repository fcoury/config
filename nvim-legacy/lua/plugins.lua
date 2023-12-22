-- reloads neovim when you save this file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, 'packer')
if not status then
  return
end

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return packer.startup(function (use)
	use 'wbthomason/packer.nvim'

	-- theme
	use {																																-- NightFox Theme
		'EdenEast/nightfox.nvim'
	}

	-- vim enhancements
	use 'ciaranm/securemodelines'         															-- Secure modelines
	use 'editorconfig/editorconfig-vim'   															-- EditorConfig plugin for Vim
	use 'numToStr/Comment.nvim'           															-- Smart and Powerful commenting plugin for neovim
	use 'mg979/vim-visual-multi'          															-- Multiple cursors plugin for vim/neovim
  use 'szw/vim-maximizer'                															-- Maximizes and restores splits
	-- use 'ggandor/leap.nvim'																							-- General-purpose motion

	-- gui enhancements
	use 'itchyny/lightline.vim'																		      -- Light and configurable statusline/tabline
	use 'machakann/vim-highlightedyank'																	-- Make the yanked region apparent
  use 'tpope/vim-surround'               															-- Surround.vim: quoting/parenthesizing made simple
  use 'vim-scripts/ReplaceWithRegister' 															-- Replace with register
	-- use 'andymass/vim-matchup'																					-- Highlight, navigate, and operate on sets of matching text

	-- other plugins
	use 'github/copilot.vim'																						-- Copilot for Vim
	use {																																-- fuzzy finder fzf
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf', run = ':call fzf#install()' }
 	}
	use { 'neoclide/coc.nvim', branch = 'release' }											-- coc
	use {																																-- file pickers
		'nvim-telescope/telescope.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		tag = '0.1.1'
	}
	use 'nvim-telescope/telescope-file-browser.nvim'
  use { 
    'nvim-telescope/telescope-fzf-native.nvim',                       -- fzf native
    run = 'make'
  }
	use {																																-- file tree (similar to VSCode)
		'nvim-tree/nvim-tree.lua',
		requires = { 'nvim-tree/nvim-web-devicons' },
		tag = 'nightly'
	}
	use 'godlygeek/tabular'																							-- aligns code, by = for instance

	-- intializations
	-- require('leap').set_default_keymaps()
	require('Comment').setup()
	require("nvim-tree").setup({
		open_on_setup_file = false,
		hijack_cursor = true,
		update_focused_file = {
			enable = true
		}
	})

  -- setup configuration after cloning packer.nvim
  if packer_bootstrap then
    require('plugins').sync()
  end
end)

