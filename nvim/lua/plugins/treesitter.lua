return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- the main branch doesn't support lazy-loading
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    local install = ts.install({ "c", "lua", "vim", "vimdoc", "query", "python", "javascript", "bash", "json" })
    -- Headless (e.g. postCreateCommand's `+qa`): finish building before nvim quits, or tree-sitter leaves stale locks
    if #vim.api.nvim_list_uis() == 0 then
      install:wait(300000)
    end

    -- The main branch enables nothing by default: install missing parsers on first use
    -- (replaces the old auto_install), then turn on highlighting and indentation
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", {}),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if not lang or not vim.list_contains(ts.get_available(), lang) then
          return
        end
        ts.install(lang):await(function()
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ev.buf) and pcall(vim.treesitter.start, ev.buf, lang) then
              vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end)
        end)
      end,
    })
  end,
}
