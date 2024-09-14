return {
	"kylechui/nvim-surround",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({})
	end,
}

-- Insert Surroundings:
-- ysiw': Surround the inner word with single quotes ('word').
-- ysiw": Surround the inner word with double quotes ("word").
-- ysiw(: Surround the inner word with parentheses ((word)).
-- ysiw{: Surround the inner word with curly braces ({word}).
-- ysiw[: Surround the inner word with square brackets ([word]).
-- ysiw<: Surround the inner word with angle brackets (<word>).
--
-- Change Surroundings:
-- cs'": Change surrounding single quotes ('word') to double quotes ("word").
-- cs([{: Change surrounding parentheses ((word)) to curly braces ({word}).
-- cs"{: Change surrounding double quotes ("word") to curly braces ({word}).
--
-- Delete Surroundings:
-- ds': Delete surrounding single quotes ('word' → word).
-- ds": Delete surrounding double quotes ("word" → word).
-- ds(: Delete surrounding parentheses ((word) → word).
--
-- Insert Surroundings for Visual Selections:
-- S': Surround visually selected text with single quotes.
-- S": Surround visually selected text with double quotes.
-- S(: Surround visually selected text with parentheses.
--
-- Insert Surroundings Line-Wise:
-- yss': Surround the entire line with single quotes.
-- yss": Surround the entire line with double quotes.
