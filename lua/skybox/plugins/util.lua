---@param buf? number
local function is_format_enabled(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g.disable_autoformat
  local baf = vim.b[buf].disable_autoformat

  -- if the buffer has a local value, use that
  if baf ~= nil then
    return not baf
  end

  -- otherwise use the global value if set, otherwise true by default
  return gaf == nil or not gaf
end

---@param  enable? boolean
---@param  buf? boolean
local function set_formatting(state, buf)
  state = state or true
  if buf then
    vim.b.disable_autoformat = not state
  else
    vim.g.disable_autoformat = not state
    vim.b.disable_autoformat = nil
  end
end

---@param buf? boolean
local function format_snacks_toggle(buf)
  return Snacks.toggle({
    name = "Autoformat (" .. (buf and "buffer" or "global") .. ")",
    get = function()
      if not buf then
        return vim.g.disable_autoformat == nil or not vim.g.autoformat
      end
      return is_format_enabled()
    end,
    set = function(state)
      set_formatting(state, buf)
    end,
  })
end

-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    opts = {
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      scope = { enabled = true },
      bigfile = { enabled = true },
      notify = { enabled = true },
      pick = { enabled = false },
      animate = { enabled = true },
      quickfile = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = {
            wrap = true
          }
        }
      },
      terminal = {
        win = {
          keys = {
            nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
            nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
            nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
            nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
          }
        }
      },
      dashboard = {
        preset = {
          pick = function(cmd, opts)
            return Skybox.pick(cmd, opts)()
          end,
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          sections = {
            { section = "header" },
            { section = "keys",   gap = 1, padding = 1 },
            { section = "startup" },
          }
        }
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- setup some globals for debugging
      _G.dd = function(...)
        Snacks.debug.inspect(...)
      end
      _G.bt = function()
        Snacks.debug.backtrace()
      end
      vim.print = _G.dd

      -- stylua: ignore start
      vim.keymap.set("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })
      vim.keymap.set("n", "<localleader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
      vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end, { desc = "Lazygit" })
      vim.keymap.set("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Git Blame Line" })
      vim.keymap.set("n", "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })
      vim.keymap.set("n", "<leader>lf", function() Snacks.lazygit.log_file() end,
        { desc = "Lazygit Current File History" })
      vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit.log() end, { desc = "Lazygit Log (cwd)" })
      -- vim.keymap.set("n", "<leader>cr", function() Snacks.rename() end, { desc = "Rename File" })
      vim.keymap.set({ "n", "t" }, "<c-,>", function() Snacks.terminal.toggle() end, { desc = "Toggle Terminal" })
      vim.keymap.set({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
      vim.keymap.set({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
      -- stylua: ignore end
      --
      vim.keymap.set({ "n", "t" }, "<leader>tf", function()
        Snacks.terminal(nil, { win = { position = "float" } })
      end, { silent = true, desc = "[T]erminal [F]loat" })

      vim.keymap.set({ "n", "t" }, "<leader>tv", function()
        Snacks.terminal(nil, { win = { position = "right" } })
      end, { silent = true, desc = "[T]erminal [V]ertical" })

      vim.keymap.set({ "n", "t" }, "<leader>th", function()
        Snacks.terminal(nil, { win = { position = "bottom" } })
      end, { silent = true, desc = "[T]erminal [H]orizontal" })

      vim.keymap.set({ "n", "t" }, "<leader>.", function()
        Snacks.scratch()
      end, { silent = true, desc = "Toggle Scratch Buffer" })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })

      -- Create some toggle mappings
      Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
      format_snacks_toggle():map("<leader>uf")
      format_snacks_toggle(true):map("<leader>uF")
      Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
      Snacks.toggle.diagnostics():map("<leader>ud")
      Snacks.toggle.line_number():map("<leader>ul")
      Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map("<leader>uc")
      Snacks.toggle.treesitter():map("<leader>uT")
      Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
      Snacks.toggle.inlay_hints():map("<leader>uh")
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>qS", function() require("persistence").select() end,              desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
  }
}
