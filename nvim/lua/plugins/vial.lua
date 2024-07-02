return {
	"fcoury/vial.nvim",
	dir = "~/code/vial",
	config = function()
		require("vial").setup({
			vial_path = "/Users/fcoury/code/vial/target/debug/vial",
			-- watchexec -c -r -e rs -- cargo $cmd
			-- wg 'test test_lex_struct_field_set -- --nocapture'
			command = "cargo test %s -- --nocapture --color=always",
			extensions = { ".rs" },
		})
	end,
}
