--[[
Must make unambiguous. There's duplicate letters:

   steno keyboard: S T K P W H R A O * E U F R P B L G T S D Z 
          encoded: 2 3 4 5 6 7 8 9 a b c d e f g h k m n p q r
--]]

---@type rules
local rules = {
   {'2',      'S'   },
   {'246',    'Y'   },
   {'2468',   'J'   },
   {'256',    'INT' },
   {'3',      'T'   },
   {'34',     'D'   },
   {'3456',   'G'   },
   {'357',    'N'   },
   {'4',      'K'   },
   {'45',     'EX'  },
   {'5',      'P'   },
   {'56',     'B'   },
   {'57',     'M'   },
   {'6',      'W'   },
   {'7',      'H'   },
   {'78',     'L'   },
   {'8',      'R'   },
   {'9',      'A'   },
   {'a',      'O'   },
   {'b',      '*'   },
   {'c',      'E'   },
   {'d',      'U'   },
   {'e',      'F'   },
   {'efgh',   'RCH' },
   {'efghkm', 'NCH' },
   {'eg',     'CH'  },
   {'f',      'R'   },
   {'fh',     'SH'  },
   {'g',      'P'   },
   {'gh',     'N'   },
   {'ghkm',   'J'   },
   {'gk',     'M'   },
   {'h',      'B'   },
   {'hm',     'K'   },
   {'k',      'L'   },
   {'m',      'G'   },
   {'n',      'T'   },
   {'p',      'S'   },
   {'q',      'D'   },
   {'r',      'Z'   },
}

local function decode(str)
   local map = {
      ['#'] = '#',
      ['2'] = 'S',
      ['3'] = 'T',
      ['4'] = 'K',
      ['5'] = 'P',
      ['6'] = 'W',
      ['7'] = 'H',
      ['8'] = 'R',
      ['9'] = 'A',
      ['a'] = 'O',
      ['b'] = '*',
      ['c'] = 'E',
      ['d'] = 'U',
      ['e'] = 'F',
      ['f'] = 'R',
      ['g'] = 'P',
      ['h'] = 'B',
      ['k'] = 'L',
      ['m'] = 'G',
      ['n'] = 'T',
      ['p'] = 'S',
      ['q'] = 'D',
      ['r'] = 'Z',
   }

   local rv = ''
   for i=1, #str do
      rv = rv .. map[str:sub(i,i)]
   end

   return rv
end

local sort_order = {
   '#', -- nothing should be #-prefixed, but need to occupy the space.
   '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c',
   'd', 'e', 'f', 'g', 'h', 'k', 'm', 'n', 'p', 'q', 'r',
}

local function encode(raw_steno)
   local rv = ''
   for i=1, #raw_steno do
      if raw_steno:sub(i,i) ~= ' ' then
         rv = rv .. sort_order[i]
      end
   end
   return rv
end


return {
   rules = rules,
   encode = encode,
   decode = decode,
}
