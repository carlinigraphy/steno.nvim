--[[

Would prefer to use `iskeyword` and `keywordprg`, but it's 

--]]


---@class (exact) datum
---@field line  string
---@field vowel string
---@field start string[]
---@field ends  string[]


---@type { string: string }
local starts_with = {
   ['D'] = -- TK
      ' [S ]TK[P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['B'] = -- PW
      ' [S ][T ][K ]PW[H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['G'] = -- TKPW
      ' [S ]TKPW[H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['F'] = -- TP
      ' [S ]T[K ]P[W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['N'] = -- TPH
      ' [S ]T[K ]P[W ]H[R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['M'] = -- PH
      ' [S ][ ][K ]P[W ]H[R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['J'] = -- SKWR
      ' S[T ]K[P ]W[H ]R[A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['Y'] = -- KWR
      ' [ ][T ]K[P ]W[H ]R[A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['V'] = -- KWR
      ' S[T ][K ][P ][W ][H ]R[A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',
}


---@type { string: string }
local ends_with = {
   ['-RCH'] = -- FRPB
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ]FRPB[L ][G ][T ][S ][D ][Z ]',

   ['-NRCH'] = -- FRPBLG
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ]FRPBLG[T ][S ][D ][Z ]',

   ['-CH'] = -- FP
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ]F[R ]P[B ][L ][G ][T ][S ][D ][Z ]',

   ['-SH'] = -- RB
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ]R[P ]B[L ][G ][T ][S ][D ][Z ]',

   ['-J'] = -- PBLG
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ]PBLG[T ][S ][D ][Z ]',

   ['-TIOUS,-CIOUS'] = -- RBS
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ]R[P ]B[L ][G ][T ]S[D ][Z ]',

   ['-TION'] = -- GS
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ]G[T ]S[D ][Z ]',

      --' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

      --' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

      --' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

      --' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',
}

---@returns datum
local function query()
   local cursor = vim.api.nvim_win_get_cursor(0)
   local row = cursor[1] - 1

   local lines = vim.api.nvim_buf_get_lines(0, row, row+1, true)
   local line = lines[1]

   ---@type datum
   local rv = {
      line  = line,
      vowel = string.match(line, '[A ][O ][* ][E ][U ]'),
      start = {},
      ends  = {},
   }

   for start, pattern in pairs(starts_with) do
      if string.match(line, pattern) then
         table.insert(rv.start, start)
      end
   end

   for ends, pattern in pairs(ends_with) do
      if string.match(line, pattern) then
         table.insert(rv.ends, ends)
      end
   end

   return rv
end


---@param data datum
local function format(data)
   local lines = { data.line, data.vowel, "" }

   local width = 1
   for _,i in ipairs(data.start) do
      if #i > width then width = #i end
   end

   local line = ''
   for i=1, math.max(#data.start, #data.ends) do
      line = '\t'

      if data.start[i] then
         line = data.start[i]
      end

      if data.ends[i] then
         while #line < 10 do
            line = line .. ' '
         end
         line = data.ends[i]
      end

      table.insert(lines, line)
   end

   return lines
end


local function display(lines)
   local buf_id = vim.api.nvim_create_buf(false, true)
   vim.api.nvim_buf_set_lines(buf_id, 0, 0, false, lines)

   local win_height = vim.api.nvim_win_get_height(0)
   local win_width  = vim.api.nvim_win_get_width(0)

   local float_width  = 20
   local float_height = math.min(#lines+1, win_height-1)
   local win_id = vim.api.nvim_open_win(buf_id, true, {
      relative = 'win',
      col      = math.floor((win_width - float_width) / 2),
      row      = 0,
      width    = float_width,
      height   = float_height,
      style    = 'minimal',
      border   = {
         {" ", ""}, -- top left
         { "", ""}, -- top
         {" ", ""}, -- top right
         {" ", ""}, -- right
         {" ", ""}, -- bottom right
         { "", ""}, -- bottom
         {" ", ""}, -- bottom left
         {" ", ""}, -- left
      },
   })

   -- Matches below largely from @koonix/vimdict.
   vim.bo.filetype = 'steno_help'
   return win_id
end


vim.keymap.set('n', 'K', function()
   display(format(query()))
end, {
   desc = "Help figure out steno by providing prefix/suffix possibilities"
})


--ABC D  E   F

--- Pass in filetypes as a variable.
--vim.api.nvim_create_autocmd('FileType', {
--   pattern = {'txt', 'steno_raw', 'steno_translation'},
--   callback = function(_)
--      vim.bo.keywordprg = [[:lua require('dictd').lookup({ confirm = false })]]
--   end
--})
