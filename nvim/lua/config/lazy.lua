local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Dotfiles are a read-only clone in devcontainers, so lazy.nvim works from a writable copy of the lockfile there
local lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
if vim.fn.filewritable(lockfile) ~= 1 then
  local copy = vim.fn.stdpath("state") .. "/lazy-lock.json"
  if not (vim.uv or vim.loop).fs_stat(copy) then
    vim.fn.mkdir(vim.fn.stdpath("state"), "p")
    vim.fn.writefile(vim.fn.readfile(lockfile), copy)
  end
  lockfile = copy
end

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  lockfile = lockfile,
  checker = { enabled = true },
})
