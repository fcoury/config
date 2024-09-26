return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()
		local ls = require("luasnip")
		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node
		local f = ls.function_node

		local function to_camel_case(args)
			local name = args[1][1]
			local result = name:gsub("_(%l)", function(c)
				return c:upper()
			end)
			return result:gsub("^%l", string.upper)
		end

		-- snippets
		ls.add_snippets("rust", {
			s("fncomp", {
				t("#[function_component("),
				f(to_camel_case, { 1 }),
				t(")]"),
				t({ "", "pub fn " }),
				i(1, "name_in_lower_case"),
				t("() -> Html {"),
				t({ "", "\t" }),
				i(0),
				t({ "", "}" }),
			}),
		})

		-- keybindings
		vim.keymap.set("i", "<C-E>", function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
				-- else
				--   vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<A-K>", true, true, true), "n")
			end
		end, { silent = true })
		vim.keymap.set("i", "<C-J>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true })
	end,
}
