-- lua/opencode-lazy/init.lua
return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	keys = {
		-- INFO: Open OpenCode in a split view. Requires two key presses.
		-- The OpenCode plugin is displayed as part of the +ai group (<leader>a).
		{
			"<leader>ao",
			function()
				require("opencode").toggle()
			end,
			desc = "Toggle (OpenCode)",
			mode = { "n", "t", "v" },
		},
		-- INFO: Open OpenCode in a split view, using a shorter keybinding.
		{
			"<C-.>",
			function()
				require("opencode").toggle()
			end,
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
		-- INFO: Scrolls the OpenCode session up by half a page.
		{
			"<S-C-d>",
			function()
				require("opencode").command("session.half.page.down")
			end,
			desc = "Page Down (OpenCode)",
			mode = "n",
		},
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			server = {
				start = function()
					require("opencode.terminal").open("opencode -c --port", {
						split = "right",
						width = math.floor(vim.o.columns * 0.35),
					})
				end,
				toggle = function()
					require("opencode.terminal").toggle("opencode -c --port", {
						split = "right",
						width = math.floor(vim.o.columns * 0.35),
					})
				end,
			},
		}

		-- Required for `opts.events.reload`.
		vim.o.autoread = true
	end,
}
