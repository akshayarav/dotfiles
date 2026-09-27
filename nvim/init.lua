-- Set Leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true

-- Treesitter folding (zc/zo/za); files open fully unfolded. No parser means no folds.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

-- Sync Neovim unnamed register with macOS system clipboard
vim.opt.clipboard = "unnamedplus"

-- Off macOS (i.e. in devcontainers) there's no pbcopy, and the forwarded $TMUX points at the host's socket,
-- so copy via OSC 52 (a tmux hook in .tmux.conf pipes it to pbcopy). Paste from the Mac with Cmd+V; "+p pastes the last yank.
if vim.fn.has("mac") == 0 then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end

-- Bootstrap lazy.nvim
require("config.lazy")
