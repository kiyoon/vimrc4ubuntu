-- place this in one of your configuration file(s)
local hop = require('hop')
local directions = require('hop.hint').HintDirection

hop.setup()

-- default find keys will use hop instead
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})
vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})

-- <space>w and <space>e for word hopping

vim.keymap.set('', '<space>w', function()
  hop.hint_words({ current_line_only = true })
end, {remap=true})

-- more advanced, use two words to search everywhere
vim.keymap.set('', '<space>f', function()
  hop.hint_char2({ })
end, {remap=true})
vim.keymap.set('n', '<space>f', function()
  hop.hint_char2({ multi_windows = true })
end, {remap=true})
