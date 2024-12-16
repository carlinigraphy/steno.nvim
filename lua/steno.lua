local expr = require('expr')

-- (const)
local STENO_WIDTH = 23


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


---@return string
--
-- Makes testing easier. Can pass in literal strings instead of `get_input()`
-- output.
local function get_input()
   local line_nr = vim.fn.line('.') - 1 --< fix api-indexing offset
   local lines   = vim.api.nvim_buf_get_lines(0, line_nr, line_nr+1, true)
   return lines[1]
end


---@param tbl table
---@param value any
--
-- Just a `table.insert` with extra steps. Can't use a reference to an
-- underlying table. Need to create a new one.
local function copy_and_push(tbl, value)
   local rv = {}
   for _,v in ipairs(tbl) do
      table.insert(rv, v)
   end
   table.insert(rv, value)
   return rv
end


---@param rules rule[]
---@param head datum
---@param negations string[]
---@param stack stack
local function parse(rules, head, negations, stack)
   ---@type datum[]
   local rv = {}

   for pattern, rule in pairs(rules) do
      if head.input
         :sub(1, #pattern)
         :match(pattern)
      then
         for _,n in ipairs(rule.negates or {}) do
            table.insert(negations, n)
         end

         table.insert(rv, {
            input = head.input:sub(1 + #pattern),
            buffer = copy_and_push(head.buffer, { pattern, rule.output }),
         })
       end
   end

   for _,v in ipairs(rv) do
      table.insert(stack, v)
   end

   return negations, stack
end


local function apply_negations(head, negations, candidates)
   local value = ''
   local ignore = {}

   for _,data in ipairs(head.buffer) do
      value = value .. data[2]
      ignore[data[1]] = true
   end

   for _,negation in ipairs(negations) do
      if ignore[negation] then
         return negations, candidates
      end
   end

   table.insert(candidates, value)
   return negations, candidates
end


---@param negations  string[]
---@param candidates string[]
---@param stack      datum[]
local function build_output(negations, candidates, stack)
   if #stack == 0 then
      return candidates
   end

   local head = table.remove(stack)
   if head.input == '' then
      local new_n, new_c = apply_negations(head, negations, candidates)
      return build_output(new_n, new_c, stack)
   else
      local new_n, new_s = parse(expr.rules, head, negations, stack)
      return build_output(new_n, candidates, new_s)
   end
end


local function query()
   display(build_output({}, {}, {
      {
         input = expr.encode(get_input()).value,
         -- TODO: created table with only `.value` key to make easier to handle
         -- astrisk as a boolean property.

         buffer = {},
         negations = {},
      }
   }))
end


return {
   query = query
}
