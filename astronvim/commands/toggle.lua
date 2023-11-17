local M = {}

local function readRootPaths()
  local file = io.open(".roots", "r")
  if file then
    local paths = {}
    for line in file:lines() do
      table.insert(paths, line)
    end
    file:close()
    return paths
  else
    return nil
  end
end

M.rootPaths = readRootPaths()
M.currentIndex = 1

function M.toggleRootPath()
  if M.rootPaths and #M.rootPaths > 0 then
    M.currentIndex = (M.currentIndex % #M.rootPaths) + 1
    local newPath = M.rootPaths[M.currentIndex]
    vim.cmd('cd ' .. newPath)
    print("Root path set to: " .. newPath)
  else
    print("No root paths found.")
  end
end

return M
