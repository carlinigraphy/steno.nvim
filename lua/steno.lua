--[[

Low-key non-functional proof of concept. Ideally will not display overlapping
outlines.

--]]

---@type { string: string }
local starts_with = {
   ['CH'] = -- KH
      ' [S ][T ]K[P ][W ]H[R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['D'] = -- TK
      ' [S ]TK[P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['B'] = -- PW
      ' [S ][T ][K ]PW[H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['F'] = -- TP
      ' [S ]T[K ]P[W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['G'] = -- TKPW
      ' [S ]TKPW[H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['N'] = -- TPH
      ' [S ]T[K ]P[W ]H[R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['M'] = -- PH
      ' [S ][ ][K ]P[W ]H[R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['V'] = -- SR
      ' S[T ][K ][P ][W ][H ]R[A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['J'] = -- SKWR
      ' S[T ]K[P ]W[H ]R[A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

   ['Y'] = -- KWR
      ' [ ][T ]K[P ]W[H ]R[A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',
}


---@type { string: string }
local ends_with = {
   ['RCH'] = -- FRPB
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ]FRPB[L ][G ][T ][S ][D ][Z ]',

   ['NRCH'] = -- FRPBLG
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ]FRPBLG[T ][S ][D ][Z ]',

   ['CH'] = -- FP
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ]F[R ]P[B ][L ][G ][T ][S ][D ][Z ]',

   ['SH'] = -- RB
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ]R[P ]B[L ][G ][T ][S ][D ][Z ]',

   ['J'] = -- PBLG
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ]PBLG[T ][S ][D ][Z ]',

   ['SHUS'] = -- RBS
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ]R[P ]B[L ][G ][T ]S[D ][Z ]',

   ['TION'] = -- GS
      ' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ]G[T ]S[D ][Z ]',

      --' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

      --' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

      --' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',

      --' [S ][T ][K ][P ][W ][H ][R ][A ][O ][* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]',
}

---@returns string[]
local function query()
   local line_nr = vim.fn.line('.') - 1 --< fix api-indexing offset
   local lines = vim.api.nvim_buf_get_lines(0, line_nr, line_nr+1, true)
   local line = lines[1]

   local prefix = {}
   for start, start_pat in pairs(starts_with) do
      if string.match(line, start_pat) then
         table.insert(prefix, start)
      end
   end

   local suffix = {}
   for ends, end_pat in pairs(ends_with) do
      if string.match(line, end_pat) then
         table.insert(suffix, ends)
      end
   end

   local rv = {}
   local fmt = ''
   local vowel = string.match(line, '[A ][O ][* ][E ][U ]')

   for _,s in ipairs(prefix) do
      fmt = s .. vowel
      for _,e in ipairs(suffix) do
         fmt = fmt .. e
      end

      fmt, _ = string.gsub(fmt, ' ', '')
      table.insert(rv, fmt)
   end

   local diff = #suffix - #prefix
   if diff > 0 then
      for i=diff, #suffix do
         fmt = vowel .. suffix[i]
         fmt, _ = string.gsub(fmt, ' ', '')
         table.insert(rv, '  '..fmt)
      end
   end

   return rv
end


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
      width    = vim.api.nvim_win_get_width(0),
      height   = #lines,
      style    = 'minimal',
   })

   vim.bo.filetype = 'steno_help'
   return win_id
end


return {
   setup = function()
      vim.keymap.set('n', 'K', function()
         display(query())
      end, { desc = "Provide raw steno suggestions" })
   end
}
