syn match texRefZone '\\shortcite\%(\*\=\)\=' nextgroup=texRefOption,texCite
syn match texRefZone '\\citeauthor\%(\*\=\)\=' nextgroup=texRefOption,texCite
syn match texRefZone '\\citeyear\%(\*\=\)\=' nextgroup=texRefOption,texCite
syn match texRefZone '\\citeyearpar\%(\*\=\)\=' nextgroup=texRefOption,texCite
