-- user defined command
local toggle = require "user.commands.toggle"
vim.api.nvim_create_user_command("ToggleRoot", toggle.toggleRootPath, {})

return {
  -- colorscheme = "nightfox",
  colorscheme = "tokyonight-night",
}
