set conceallevel=2 concealcursor=nvc
hi! link Conceal Normal

syntax match stenoHelpVowel_A '\Ca'  conceal cchar=A
syntax match stenoHelpVowel_E '\Ce'  conceal cchar=E
syntax match stenoHelpVowel_O '\Co'  conceal cchar=O
syntax match stenoHelpVowel_U '\Cu'  conceal cchar=U
syntax match stenoHelpVowel_I '\Ceu' conceal cchar=I

" Intentionally not matching 'aeu' above, as the diphthong makes more sense in
" my mind.
"
" Also don't think I can use `conceal` to match long vowels w/ `*'. Can only
" conceal with 0 or 1 character(s). Don't know a good way around this (yet).
"
syntax match stenoHelpVowel_LongO '\Coe'   conceal cchar=Ō
syntax match stenoHelpVowel_LongE '\Caoe'  conceal cchar=Ē
syntax match stenoHelpVowel_LongU '\Caou'  conceal cchar=Ū
syntax match stenoHelpVowel_LongI '\Caoeu' conceal cchar=Ī
