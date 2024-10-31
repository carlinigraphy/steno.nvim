package.loaded.expr = nil
local expr = require('expr')

local STENO_WIDTH = 23
local MAX_ITERATIONS = 100

---@alias datum [string, integer]

---@class stack
---@field data datum[]
local stack = {}
stack.data = { {'', 1} }

---@param v datum
---@return nil
function stack:push(v) table.insert(self.data, v) end

---@return datum
function stack:pop() return table.remove(self.data) end


---@returns string[]
local function query()
   --local line_nr = vim.fn.line('.') - 1 --< fix api-indexing offset
   --local lines   = vim.api.nvim_buf_get_lines(0, line_nr, line_nr+1, true)
   --local encoded = expr.encode(lines[1])
   local encoded = expr.encode('  TK     O  U  PB      ')

   -- Can't process an empty line.
   if encoded == '' then return end

   ---@type integer
   --- Tracking iterations. Explode if it gets too high.
   local times = 1

   while #stack.data > 0 do
      times = times + 1
      assert(times < MAX_ITERATIONS, '$MAX_ITERATIONS exceeded' .. vim.inspect(
         stack.data
      ))

      local item = stack:pop()
      local collect = item[1]
      local position = item[2]

      for _,rule in ipairs(expr.rules) do
         local output = rule[1]
         local pattern = rule[2]

         if encoded:match(pattern, position) then
            stack:push({ collect..output, position })
         end
      end
   end

   print(vim.inspect(stack.data))
end

-- DEBUG
query()


local function display(lines)
   -- Wondering if I want to display something to indicate there are no
   -- results.
   if #lines == 0 then return end

   local buf_id = vim.api.nvim_create_buf(false, true)
   vim.api.nvim_buf_set_lines(buf_id, 0, 1, false, lines)

   local float_width = 0
   for _,l in ipairs(lines) do
      if #l > float_width then float_width = #l end
   end

   local win_id = vim.api.nvim_open_win(buf_id, true, {
      relative = 'win',
      row      = vim.fn.winline(),
      col      = 0,
      width    = STENO_WIDTH,
      height   = #lines,
      style    = 'minimal',
   })

   vim.bo.filetype = 'steno_help'
   return win_id
end


return {
   setup = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'steno_raw' },
        callback = function(_)
           vim.keymap.set('n', 'K', function()
              --display(query())
              query()
           end, { desc = "Provide raw steno suggestions" })
        end
     })
   end
}
