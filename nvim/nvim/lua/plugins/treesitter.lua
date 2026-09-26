return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "javascript", "bash", "json" },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    -- On the main branch, Treesitter uses setup on the root module or native neovim API
    local status, configs = pcall(require, "nvim-treesitter.configs")
    if status then
      configs.setup(opts)
    end
  end,
}
