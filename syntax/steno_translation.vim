syn match stenoTranslationRawSlash  "/"  contained containedin=stenoTranslationRaw
syn match stenoTranslationRaw       "\C\v(-|<S?T?K?P?W?H?R?A?O?\*?E?U?)F?R?P?B?L?G?T?S?D?Z?(/(-|S?T?K?P?W?H?R?A?O?\*?E?U?)F?R?P?B?L?G?T?S?D?Z?)*>"
   \ containedin=stenoTranslationNote
   \ contains=@NoSpell
" Okay, this is a bit of a mess. Can be broken down into parts:
"     (- | ...)            Can use dash to substitute for the initial bank of
"                          letters
"     (- | <...)           /< requires letters begin on a word boundary
"                          :help /ordinary-atom
"     ... (/ (- | ...))*>  May repeat on slash separator, ends on word
"                          boundary

" Box drawing chars cannot be `syn keyword`s. Gotta match as:
syn match stenoTranslationBox       "[┐│]"
syn match stenoTranslationHr        "\v^─+$" 

syn match stenoTranslationQuestion  "\v^\s*Q\.\s+"
syn match stenoTranslationAnswer    "\v^\s*A\.\s+"

syn match stenoTranslationReview    "REVIEW::"   contains=stenoTranslationNote
syn match stenoTranslationError     "ERROR::"    contains=stenoTranslationNote
syn region stenoTranslationNote     start="::"  end="\n"  contained

hi! def link stenoTranslationRaw          String
hi! def link stenoTranslationReview       WarningMsg
hi! def link stenoTranslationError        ErrorMsg
hi! def link stenoTranslationRawSlash     Comment
hi! def link stenoTranslationNote         Comment
hi! def link stenoTranslationBox          Comment
hi! def link stenoTranslationHr           Comment
hi! def link stenoTranslationQuestion     Conditional
hi! def link stenoTranslationAnswer       Conditional
