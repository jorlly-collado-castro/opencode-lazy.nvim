local function opencode_toggle()
  local opts = vim.g.opencode_opts or {}
  if opts.server and opts.server.toggle then
    opts.server.toggle()
  elseif opts.server and opts.server.start then
    opts.server.start()
  else
    vim.notify("OpenCode server not configured", vim.log.levels.ERROR, { title = "opencode" })
  end
end

return {
  "NickvanDyke/opencode.nvim",
  version = "*",
  dependencies = {
    {
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {},
        picker = {},
        terminal = {},
      },
    },
    {
      "folke/which-key.nvim",
      opts = {
        spec = {
          { "<leader>a", mode = { "n", "x" }, group = "OpenCode" },
          { "<leader>ap", mode = { "n", "x" }, group = "Prompt" },
        },
      },
    },
  },
  keys = {
    {
      "<leader>ao",
      opencode_toggle,
      desc = "Toggle (OpenCode)",
      mode = { "n", "t", "v" },
    },
    {
      "<C-.>",
      opencode_toggle,
      desc = "Toggle Quick (OpenCode)",
      mode = { "n", "t", "v" },
    },
    {
      "<leader>aa",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      desc = "Ask (OpenCode)",
      mode = { "n", "v" },
    },
    {
      "<leader>ax",
      function()
        require("opencode").select()
      end,
      desc = "Action (OpenCode)",
      mode = { "n", "v" },
    },
    {
      "<leader>ap",
      function()
        require("opencode").prompt("@this")
      end,
      desc = "Add (OpenCode)",
      mode = { "n", "v" },
    },
    {
      "<S-C-u>",
      function()
        require("opencode").command("session.half.page.up")
      end,
      desc = "Page Up (OpenCode)",
      mode = "n",
    },
    {
      "<S-C-d>",
      function()
        require("opencode").command("session.half.page.down")
      end,
      desc = "Page Down (OpenCode)",
      mode = "n",
    },
    {
      "<leader>ai",
      function()
        require("opencode").ask("", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Ask (OpenCode)",
    },
    {
      "<leader>aI",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Ask with context (OpenCode)",
    },
    {
      "<leader>ab",
      function()
        require("opencode").ask("@file: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Ask about buffer (OpenCode)",
    },
    {
      "<leader>ape",
      function()
        require("opencode").prompt("explain", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Explain (OpenCode)",
    },
    {
      "<leader>apf",
      function()
        require("opencode").prompt("fix", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Fix (OpenCode)",
    },
    {
      "<leader>apd",
      function()
        require("opencode").prompt("diagnose", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Diagnose (OpenCode)",
    },
    {
      "<leader>apr",
      function()
        require("opencode").prompt("review", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Review (OpenCode)",
    },
    {
      "<leader>apt",
      function()
        require("opencode").prompt("test", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Test (OpenCode)",
    },
    {
      "<leader>apo",
      function()
        require("opencode").prompt("optimize", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Optimize (OpenCode)",
    },
    {
      "go",
      function()
        return require("opencode").operator("@this ")
      end,
      expr = true,
      mode = { "n", "x" },
      desc = "Add range (OpenCode)",
    },
    {
      "goo",
      function()
        return require("opencode").operator("@this ") .. "_"
      end,
      expr = true,
      mode = { "n" },
      desc = "Add line (OpenCode)",
    },
  },
  config = function()
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open("opencode -c --port", {
            win = { position = "right", width = math.floor(vim.o.columns * 0.35) },
          })
        end,
        toggle = function()
          require("snacks.terminal").toggle("opencode -c --port", {
            win = { position = "right", width = math.floor(vim.o.columns * 0.35) },
          })
        end,
      },
    }

    vim.o.autoread = true

    vim.api.nvim_create_autocmd({ "TermOpen" }, {
      group = vim.api.nvim_create_augroup("opencode_buffer", { clear = false }),
      pattern = "*:opencode --port*",
      desc = "Assign binds specific to OpenCode buffers",
      callback = function(event)
        local bufname = vim.api.nvim_buf_get_name(event.buf)

        if string.match(bufname, "^term:.+//%d+:opencode %-%-port.*$") then
          require("which-key").add({
            buffer = event.buf,
            mode = { "n", "t" },
            {
              "<C-U>",
              function()
                require("opencode").command("session.half.page.up")
              end,
              desc = "Half scroll backward (OpenCode)",
            },
            {
              "<C-D>",
              function()
                require("opencode").command("session.half.page.down")
              end,
              desc = "Half scroll forward (OpenCode)",
            },
            {
              "<C-B>",
              function()
                require("opencode").command("session.page.up")
              end,
              desc = "Scroll backward (OpenCode)",
            },
            {
              "<C-F>",
              function()
                require("opencode").command("session.page.down")
              end,
              desc = "Scroll forward (OpenCode)",
            },
          })
        end
      end,
    })
  end,
}
