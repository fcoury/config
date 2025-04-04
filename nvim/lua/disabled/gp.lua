return {
	"robitx/gp.nvim",
	config = function()
		local conf = {
			openai_api_key = os.getenv("OPENAI_API_KEY"),
		}
		require("gp").setup(conf)

		-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
	end,
}
