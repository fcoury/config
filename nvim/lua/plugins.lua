return require('packer').startup(function ()
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
	use 'ggandor/leap.nvim'																							-- General-purpose motion
	use 'airblade/vim-rooter'																						-- Changes pwd to project root

	-- gui enhancements
	use 'itchyny/lightline.vim'																					-- Light and configurable statusline/tabline
	use 'machakann/vim-highlightedyank'																	-- Make the yanked region apparent
	use 'andymass/vim-matchup'																					-- Highlight, navigate, and operate on sets of matching text

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
	use {																																-- file tree (similar to VSCode)
		'nvim-tree/nvim-tree.lua',
		requires = { 'nvim-tree/nvim-web-devicons' },
		tag = 'nightly'
	}
	use 'godlygeek/tabular'																							-- aligns code, by = for instance

	-- intializations
	require('leap').set_default_keymaps()
	require('Comment').setup()
	require("nvim-tree").setup({
		open_on_setup_file = false,
		hijack_cursor = true,
		update_focused_file = {
			enable = true
		}
	})

end)
