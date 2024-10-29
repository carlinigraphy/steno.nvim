syn match stenoRawText  "\v^ [S ][T ][K ][P ][W ][H ][R ][A ][O ][\* ][E ][U ][F ][R ][P ][B ][L ][G ][T ][S ][D ][Z ]"  contains=stenoRawUndo

syn match stenoRawNumber "\v^#\s*[STPHAOFPLTD]\s*$"
syn match stenoRawUndo   "\v^\s+\*\s+$"  contained containedin=stenoRawText1

hi! link stenoRawText     Normal
hi! link stenoRawNumber   String
hi! link stenoRawUndo     WarningMsg
