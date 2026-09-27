return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local objects = {
      af = { "@function.outer", "a function" },
      ["if"] = { "@function.inner", "inner function" },
      ac = { "@class.outer", "a class" },
      ic = { "@class.inner", "inner class" },
      aa = { "@parameter.outer", "a parameter" },
      ia = { "@parameter.inner", "inner parameter" },
    }
    for lhs, obj in pairs(objects) do
      vim.keymap.set({ "x", "o" }, lhs, function()
        select.select_textobject(obj[1], "textobjects")
      end, { desc = obj[2] })
    end

    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      move.goto_next_start("@function.outer", "textobjects")
    end, { desc = "Next function" })
    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      move.goto_previous_start("@function.outer", "textobjects")
    end, { desc = "Previous function" })
  end,
}
