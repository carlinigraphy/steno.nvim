local expr = require('expr')

local STENO_WIDTH = 23
local MAX_ITERATIONS = 100

---@class (exact) datum
---@field buf string
---@field input string

---@alias rule [string, string]
---@alias rules rule[]

---@param rules rules
---@param head datum
---@param stack stack
local function inner(rules, head, stack)
   local rv = {}

   for _, rule in ipairs(rules) do
      if head.input
            :sub(1, #rule[1])
            :match(rule[1])
      then
         table.insert(rv, {
            buf = head.buf .. rule[2],
            input = head.input:sub(1 + #rule[1])
         })
       end
   end

   for _,v in ipairs(rv) do
      table.insert(stack, v)
   end

   return stack
end


---@returns string[]
local function query()
   local line_nr = vim.fn.line('.') - 1 --< fix api-indexing offset
   local lines   = vim.api.nvim_buf_get_lines(0, line_nr, line_nr+1, true)

   ---@alias stack datum[]
   ---@type stack
   local stack = {
      { buf='', input=expr.encode(lines[1]) }
   }

   -- Can't process an empty line.
   if encoded == '' then return end

   ---@type datum
   local head = {
      buf = '',
      input = '',
   }

   ---@type string[]
   local candidates = {}

   local overflow = 1
   while #stack > 0 do
      overflow = overflow + 1
      assert(overflow < MAX_ITERATIONS, '$MAX_ITERATIONS exceeded')

      head = table.remove(stack)
      if head.input == '' then
         table.insert(candidates, head.buf)
      else
         stack = inner(expr.rules, head, stack)
      end
   end

   return candidates
end


local function display(lines)
   -- Wondering if I want to display something to indicate there are no
   -- results.
   if #lines == 0 then return end

   -- Right pad. Allows placing the cursor on the whitespace at the top-right
   -- of the box. Else cannot seek the cursor to a non-text position.
   for i,line in ipairs(lines) do
      lines[i] = line .. string.rep('', STENO_WIDTH + 1 - #line, ' ')
   end

   local buf_id = vim.api.nvim_create_buf(false, true)
   vim.api.nvim_buf_set_lines(buf_id, 0, 1, false, lines)

   local win_id = vim.api.nvim_open_win(buf_id, true, {
      relative = 'win',
      row      = vim.fn.winline(),
      col      = 0,
      width    = STENO_WIDTH,
      height   = #lines,
      style    = 'minimal',
   })

   vim.api.nvim_win_set_cursor(0, {1, STENO_WIDTH})
   vim.bo.filetype = 'steno_help'

   return win_id
end


return {
   setup = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'steno_raw' },
        callback = function(_)
           vim.keymap.set('n', 'K', function()
              display(query())
           end, { desc = "Provide raw steno suggestions" })
        end
     })
   end
}
