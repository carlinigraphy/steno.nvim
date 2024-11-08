--[[
Must make unambiguous. There's duplicate letters:

   steno keyboard: S T K P W H R A O * E U F R P B L G T S D Z 
          encoded: 2 3 4 5 6 7 8 9 a b c d e f g h k m n p q r

Vowels are the only letters output in lower case. Allows for syntax matching on
them. Can conceal 'eu' -> 'I', or 'aoeu' -> 'Ī'.

--]]

---@type table<string, rule>
local RULES = {
   ['2'     ] = { output = 'S'    },
   ['2468'  ] = { output = 'J'    },
   ['256'   ] = { output = 'INT',
      negates = { '2', '5', '56' }
   },
   ['28'    ] = { output = 'V'    },
   ['3'     ] = { output = 'T'    },
   ['34'    ] = { output = 'D'    },
   ['3456'  ] = { output = 'G'    },
   ['357'   ] = { output = 'N',
      negates = { '3', '5', '7' }
   },
   ['4'     ] = { output = 'K'    },
   ['45'    ] = { output = 'EX'   },
   ['468'   ] = { output = 'Y',
      negates = { '4', '6', '8' }
   },
   ['5'     ] = { output = 'P'    },
   ['56'    ] = { output = 'B',
      negates = { '5', '6' }
   },
   ['57'    ] = { output = 'M'    },
   ['6'     ] = { output = 'W'    },
   ['7'     ] = { output = 'H'    },
   ['78'    ] = { output = 'L'    },
   ['8'     ] = { output = 'R'    },
   ['9'     ] = { output = 'a'    },    --< intentionally lower case
   ['a'     ] = { output = 'o'    },    --< intentionally lower case
   ['b'     ] = { output = '*'    },
   ['c'     ] = { output = 'e'    },    --< intentionally lower case
   ['d'     ] = { output = 'u'    },    --< intentionally lower case
   ['e'     ] = { output = 'F'    },
   ['efgh'  ] = { output = 'RCH'  },
   ['efghkm'] = { output = 'NCH'  },
   ['eg'    ] = { output = 'CH'   },
   ['f'     ] = { output = 'R'    },
   ['fh'    ] = { output = 'SH'   },
   ['fhp'   ] = { output = 'SHUS' },
   ['g'     ] = { output = 'P'    },
   ['gh'    ] = { output = 'N'    },
   ['ghkm'  ] = { output = 'J'    },
   ['gk'    ] = { output = 'M'    },
   ['gkn'   ] = { output = 'MENT' },
   ['h'     ] = { output = 'B'    },
   ['hm'    ] = { output = 'K'    },
   ['k'     ] = { output = 'L'    },
   ['m'     ] = { output = 'G'    },
   ['mn'    ] = { output = 'TH'   },
   ['n'     ] = { output = 'T'    },
   ['p'     ] = { output = 'S'    },
   ['q'     ] = { output = 'D'    },
   ['r'     ] = { output = 'Z'    },
}

local SORT_ORDER = {
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
   local value = ''
   for i=1, #raw_steno do
      if raw_steno:sub(i,i) ~= ' ' then
         value = value .. SORT_ORDER[i]
      end
   end
   return { value = value }
end


return {
   rules  = RULES,
   encode = encode,
   decode = decode,
}
