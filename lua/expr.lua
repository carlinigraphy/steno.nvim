--[[

Must make unambiguous. There's duplicate letters:

   steno keyboard: S T K P W H R A O * E U F R P B L G T S D Z 
          encoded: 2 3 4 5 6 7 8 9 a b c d e f g h k m n p q r

--]]

local rules = {
   { 'S', '2'    },
   { 'T', '3'    },
   { 'K', '4'    },
   { 'D', '34'   },
   { 'P', '5'    },
   -- { 'X', '45'   },
   { 'W', '6'    },
   -- { 'B', '56'   },
   -- { 'G', '3456' },
   -- { 'J', '2468' },
   -- { 'Y', '246'  },
   { 'H', '7'    },
   { 'R', '8'    },

   -- vowels.
   { 'A', '9'    },
   { 'O', 'a'    },
   { '*', 'b'    },
   { 'E', 'c'    },
   { 'U', 'd'    },

   -- Work on these more after verifying the initial bit works.
   { 'F',    'e'    },
   { 'R',    'f'    },
   { 'P',    'g'    },
   -- { 'CH',   'eg'   },
   { 'B',    'h'    },
   { 'N',    'gh'   },
   -- { 'SH',   'fh'   },
   -- { 'RCH',  'efgh' },
   { 'L',    'k'    },
   { 'M',    'gk'   },
   { 'G',    'm'    },
   { 'T',    'n'    },
   { 'S',    'p'    },
   { 'T',    'q'    },
   { 'Z',    'r'    },

   -- ...
}

local sort_order = {
   '#', -- nothing should be #-prefixed, but need to occupy the space.
   '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c',
   'd', 'e', 'f', 'g', 'h', 'k', 'm', 'n', 'p', 'q', 'r',
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
