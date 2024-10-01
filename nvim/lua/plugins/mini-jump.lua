return {
	"echasnovski/mini.jump",
	version = false,
	config = function()
		require("mini.jump").setup({
			mappings = {
				forward = "f",
				backward = "F",
				forward_till = "t",
				backward_till = "T",
				repeat_jump = "",
			},

			-- a very big number (like 10^7) to virtually disable.
			delay = {
				-- Delay between jump and highlighting all possible jumps
				highlight = 250,

				-- Delay between jump and automatic stop if idle (no jump is done)
				idle_stop = 10000000,
			},
		})
	end,
}
