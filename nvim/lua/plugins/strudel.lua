return {
  -- Live-code music with Strudel (strudel.cc): syncs the buffer to a Strudel browser window driven by Puppeteer
  -- Mac only: the browser window and audio have to run on the Mac, not in a devcontainer
  "gruvw/strudel.nvim",
  cond = vim.fn.has("mac") == 1,
  build = "npm ci",
  lazy = false, -- lazy-loading breaks .str file type detection
  keys = {
    { "<leader>sl", function() require("strudel").launch() end, desc = "Launch Strudel" },
    { "<leader>sq", function() require("strudel").quit() end, desc = "Quit Strudel" },
    { "<leader>st", function() require("strudel").toggle() end, desc = "Toggle play/stop" },
    { "<leader>su", function() require("strudel").update() end, desc = "Update (evaluate)" },
    { "<leader>ss", function() require("strudel").stop() end, desc = "Stop playback" },
    { "<leader>sb", function() require("strudel").set_buffer() end, desc = "Sync current buffer" },
    { "<leader>sx", function() require("strudel").execute() end, desc = "Sync current buffer and update" },
  },
  opts = {
    -- Keep Strudel's own editor visible, so playing patterns light up next to nvim
    ui = { maximise_menu_panel = false },
    -- :w re-evaluates while playing
    update_on_save = true,
  },
}
