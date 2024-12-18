# steno.nvim
Collection of functions & functionality for reading, translating, and editing machine stenography.

# Usage
## Prepare
Open a vertical split with (1) a raw steno file, and (2) a file for the translated output.
```
  ┌─────┬──────────────────────┐  
  │     │                      │  
  │     │                      │  
  │     │                      │  
  │ (1) │        (2)           │  
  │     │                      │  
  │     │                      │  
  │     │                      │  
  └─────┴──────────────────────┘  
```

Throw a function into your ~/.bashrc containing something like...
```bash
nvim \
    +'setf steno_raw' \
    +'vert split | b .steno_translation | vert 1res 23' \
    file_1.steno_raw \
    file_1.steno_translation}"
```

## Functionality
In the raw window (1)...
1. `scrollbind` is set
2. Hover a line of steno text and press `K` to see a list of valid expansions in a floating window
    - Note, this does NOT "translate" anything.
      Given the input `TKRAEUPB`, the following list of expansions is proposed:
      - `TKRAIPB`
      - `TKRAIN`
      - `DRAIPB`
      - `DRAIN`
    - The expansions are hard-coded for _my_ steno theory; they may not align with yours
    - Press `q` or `<Esc>` to close the float

In the translation window (2)...
1. `scrollbind` is set
2. Insert-mode bindings
    - `<C-h>` -> correct previous misspelling (`1z=`) and return cursor to the current position
    - `<leader>fe` -> (mnemonic: "(f)ind (e)rrors") finds instances of "REVIEW" or "ERROR" in the current file,
      and opens in the quickfix window
3. Insert-mode abbreviations for formatting and "TODO" markers for errors/review
    - `:hr` -> insert a horizontal rule
    - `:re` -> `REVIEW::`
    - `:er` -> `ERROR::`
    - `kj` -> insert box-drawing character to indicate a line continuation
4. Highlight groups for
    - The above `REVIEW::`/`ERROR::` abbreviations
    - In-line raw steno text

# Setup
1. Install the plugin

## Native
```bash
PLUGIN_DIR=~/.local/share/nvim/site/pack/plugins/start/
mkdir -p "$PLUGIN_DIR"
git clone 'https://git.sr.ht/~carlinigraphy/steno.nvim' "$PLUGIN_DIR"
```

## Lazy
```lua
{ "https://git.sr.ht/~carlinigraphy/steno.nvim" }
```
