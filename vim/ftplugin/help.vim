" As vim help files are often stored as *.txt, the filetype options specific to
" text files get enabled in them. This is particularly annoying when it comes
" to spell checking being enabled by default for texts. As help files are read
" only, there is no point for us to use spell checking when using the help
" system.
setlocal nospell
