-- local FileNameBlock = {
--   -- let's first set up some attributes needed by this component and it's children
--   init = function(self)
--     self.filename = vim.api.nvim_buf_get_name(0)
--   end,
-- }
--
-- local FileIcon = {
--   init = function(self)
--     local filename = self.filename
--     local extension = vim.fn.fnamemodify(filename, ":e")
--     self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
--   end,
--   provider = function(self)
--     return self.icon and (self.icon .. " ")
--   end,
--   hl = function(self)
--     return { fg = self.icon_color }
--   end
-- }
--
-- local FileName = {
--   provider = function(self)
--     -- first, trim the pattern relative to the current directory. For other
--     -- options, see :h filename-modifers
--     local filename = vim.fn.fnamemodify(self.filename, ":.")
--     if filename == "" then return "[No Name]" end
--     -- now, if the filename would occupy more than 1/4th of the available
--     -- space, we trim the file path to its initials
--     -- See Flexible Components section below for dynamic truncation
--     if not conditions.width_percent_below(#filename, 0.25) then
--       filename = vim.fn.pathshorten(filename)
--     end
--     return filename
--   end,
--   hl = { fg = utils.get_highlight("Directory").fg },
-- }
--
-- local FileFlags = {
--   {
--     condition = function()
--       return vim.bo.modified
--     end,
--     provider = "[+]",
--     hl = { fg = "green" },
--   },
--   {
--     condition = function()
--       return not vim.bo.modifiable or vim.bo.readonly
--     end,
--     provider = "",
--     hl = { fg = "orange" },
--   },
-- }
--
-- local FileNameModifer = {
--   hl = function()
--     if vim.bo.modified then
--       -- use `force` because we need to override the child's hl foreground
--       return { fg = "cyan", bold = true, force = true }
--     end
--   end,
-- }
--
-- FileNameBlock = utils.insert(FileNameBlock,
--   FileIcon,
--   utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
--   FileFlags,
--   { provider = '%<' }                      -- this means that the statusline is cut here when there's not enough space
-- )

return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require("astronvim.utils.status")
    print(vim.inspect(status))
    opts.statusline = {                                                            -- statusline
      hl = { fg = "fg", bg = "bg" },
      status.component.mode { mode_text = { padding = { left = 1, right = 1 } } }, -- add the mode text
      status.component.git_branch(),
      status.component.file_info {
        filetype = false,
        filename = {
          padding = { right = 1 },
          modify = ":.",
          hl = { fg = "fg", bg = "bg" }
        },
        file_modified = false
      },
      -- status.component.file_info(),
      status.component.git_diff(),
      status.component.diagnostics(),
      status.component.fill(),
      status.component.cmd_info(),
      status.component.fill(),
      status.component.lsp(),
      status.component.treesitter(),
      status.component.nav(),
      -- remove the 2nd mode indicator on the right
    }

    -- return the final configuration table
    return opts
  end,
}
