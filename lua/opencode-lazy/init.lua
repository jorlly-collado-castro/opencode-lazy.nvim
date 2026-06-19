-- lua/opencode-lazy/init.lua

-- Helper to toggle OpenCode terminal using snacks.terminal if available.
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
		---@module "snacks"
		{
			"folke/snacks.nvim",
			optional = true,
			opts = {
				input = {}, -- Enhances `ask()`.
				picker = {}, -- Enhances `select()`.
				terminal = {}, -- Enables the `snacks` provider.
			},
		},
		---@module "which-key"
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
		-- INFO: Open OpenCode in a split view. Requires two key presses.
		-- The OpenCode plugin is displayed as part of the +ai group (<leader>a).
		{
			"<leader>ao",
			opencode_toggle,
			desc = "Toggle (OpenCode)",
			mode = { "n", "t", "v" },
		},
		-- INFO: Open OpenCode in a split view, using a shorter keybinding.
		{
			"<C-.>",
			opencode_toggle,
			desc = "Toggle Quick (OpenCode)",
			mode = { "n", "t", "v" },
		},

		-- INFO: Opens the OpenCode prompt with the current selection as the input.
		{
			"<leader>aa",
			function()
				require("opencode").ask("@this: ", { submit = true })
			end,
			desc = "Ask (OpenCode)",
			mode = { "n", "v" },
		},
		-- INFO: Opens the OpenCode prompt with the current selection as the input, but does not submit it.
		{
			"<leader>ax",
			function()
				require("opencode").select()
			end,
			desc = "Action (OpenCode)",
			mode = { "n", "v" },
		},
		-- INFO: Opens the OpenCode prompt with the current selection as the input, allowing you to add it to the session.
		{
			"<leader>ap",
			function()
				require("opencode").prompt("@this")
			end,
			desc = "Add (OpenCode)",
			mode = { "n", "v" },
		},

		-- INFO: Scrolls the OpenCode session up by half a page.
		{
			"<S-C-u>",
			function()
				require("opencode").command("session.half.page.up")
			end,
			desc = "Page Up (OpenCode)",
			mode = "n",
		},
		-- INFO: Scrolls the OpenCode session down by half a page.
		{
			"<S-C-d>",
			function()
				require("opencode").command("session.half.page.down")
			end,
			desc = "Page Down (OpenCode)",
			mode = "n",
		},

		------------------------------------------------------------------------------------------------------
		-- INFO: Ask a question.
		{
			"<leader>ai",
			function()
				require("opencode").ask("", { submit = true })
			end,
			mode = { "n", "x" },
			desc = "Ask (OpenCode)",
		},
		-- INFO: Ask a question about the current context.
		{
			"<leader>aI",
			function()
				require("opencode").ask("@this: ", { submit = true })
			end,
			mode = { "n", "x" },
			desc = "Ask with context (OpenCode)",
		},
		-- INFO: Ask a question about the current buffer.
		{
			"<leader>ab",
			function()
				require("opencode").ask("@file: ", { submit = true })
			end,
			mode = { "n", "x" },
			desc = "Ask about buffer (OpenCode)",
		},
		------------------------------------------------------------------------------------------------------
		-- INFO: Prompt OpenCode to explain the code.
		{
			"<leader>ape",
			function()
				require("opencode").prompt("explain", { submit = true })
			end,
			mode = { "n", "x" },
			desc = "Explain (OpenCode)",
		},
		-- INFO: Prompt OpenCode to fix the code.
		{
			"<leader>apf",
			function()
				require("opencode").prompt("fix", { submit = true })
			end,
			mode = { "n", "x" },
			desc = "Fix (OpenCode)",
		},
		-- INFO: Prompt OpenCode to diagnose the code.
		{
			"<leader>apd",
			function()
				require("opencode").prompt("diagnose", { submit = true })
			end,
			mode = { "n", "x" },
			desc = "Diagnose (OpenCode)",
		},
		-- INFO: Prompt OpenCode to review the code.
		{
			"<leader>apr",
			function()
				require("opencode").prompt("review", { submit = true })
			end,
			mode = { "n", "x" },
			desc = "Review (OpenCode)",
		},
		-- INFO: Prompt OpenCode to generate tests.
		{
			"<leader>apt",
			function()
				require("opencode").prompt("test", { submit = true })
			end,
			mode = { "n", "x" },
			desc = "Test (OpenCode)",
		},
		-- INFO: Prompt OpenCode to optimize the code.
		{
			"<leader>apo",
			function()
				require("opencode").prompt("optimize", { submit = true })
			end,
			mode = { "n", "x" },
			desc = "Optimize (OpenCode)",
		},
		------------------------------------------------------------------------------------------------------
		-- INFO: Add a range to OpenCode.
		{
			"go",
			function()
				return require("opencode").operator("@this ")
			end,
			expr = true,
			mode = { "n", "x" },
			desc = "Add range (OpenCode)",
		},
		-- INFO: Add a line to OpenCode.
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
		---@type opencode.Opts
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

		-- Required for `opts.events.reload`.
		vim.o.autoread = true

		vim.api.nvim_create_autocmd({ "TermOpen" }, {
			group = vim.api.nvim_create_augroup("opencode_buffer", { clear = false }),
			pattern = "*:opencode --port*",
			desc = "Assign binds specific to OpenCode buffers",
			callback = function(event)
				local bufname = vim.api.nvim_buf_get_name(event.buf) ---@type string

				-- Example: `term://.../nvim/lua/plugins//58118:opencode --port`
				-- The dashes in `--port` must be escaped because it is a special
				-- character in Lua's flavour of regex patterns.
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
