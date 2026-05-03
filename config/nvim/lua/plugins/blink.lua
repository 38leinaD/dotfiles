-- Make <CR> insert a real newline unless an item was actively picked.
-- Needs both halves: preselect=false stops blink from auto-highlighting the
-- first suggestion (otherwise the "enter" preset would accept it on <CR>),
-- and the "enter" preset wires <CR> to accept-or-fallback so a normal newline
-- still works when nothing is selected.
return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      list = {
        selection = { preselect = false, auto_insert = false },
      },
    },
    keymap = {
      preset = "enter",
    },
  },
}
