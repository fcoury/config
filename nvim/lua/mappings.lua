nmap(';', ':')                                        -- use ; as a command prefix
nmap('<leader>w', ':w<CR>')                           -- quick-save
nmap(']<Space>', 'o<Esc>')                            -- quick-insert line below
nmap('[<Space>', 'O<Esc>')                            -- quick-insert line above
nmap('<C-j>', ':nohlsearch<CR>')                      -- Ctrl+J clear search highlight
vmap('<C-j>', ':nohlsearch<CR>')                      -- Ctrl+J clear search highlight
map('', 'H', '^')                                     -- move to beginning of line with H
map('', 'L', '$')                                     -- move to end of line with L
nmap('<leader><leader>', '<c-^>')                     -- quick switch between buffers

-- copy and paste with system clipboard
nmap('<leader>p', ':read !pbpaste<cr>')
nmap('<leader>c', ':w !pbcopy<cr><cr>')

-- open adjacent file
nmap('<leader>o', ':e ' .. vim.fn.expand('%:p:h') .. '/')

-- telescope mappings
nmap('<leader>f', '<cmd>Telescope find_files<cr>')    -- open file search
nmap('<leader>xg', '<cmd>Telescope live_grep<cr>')    -- search for pattern in files
nmap('<leader>xb', '<cmd>Telescope buffers<cr>')      -- open buffer list
nmap('<leader>xh', '<cmd>Telescope help_tags<cr>')    -- search for help tags
nmap('<leader>xs', '<cmd>Telescope file_browser<cr>') -- open file browser

-- nvim-tree mappings
nmap('<leader>t', ':NvimTreeToggle<CR>')
nmap('<leader>,', ':NvimTreeFindFileToggle<CR>')
