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

-- Briefly flash the yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("UserYankHighlight", {}),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Sync Neovim unnamed register with macOS system clipboard
vim.opt.clipboard = "unnamedplus"

-- Off macOS (i.e. in devcontainers) there's no pbcopy, and the forwarded $TMUX points at the host's socket,
-- so use OSC 52: copies reach the Mac via a tmux hook that pipes to pbcopy, and pastes ask tmux,
-- which fetches the Mac clipboard from iTerm2 (get-clipboard in .tmux.conf)
if vim.fn.has("mac") == 0 then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end

-- Bootstrap lazy.nvim
require("config.lazy")
