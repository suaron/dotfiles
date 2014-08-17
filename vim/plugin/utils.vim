" Google search from the command line
command! -narg=1 GoogleSearch :silent exe '!open https://google.com/search?q='.<q-args>.'&'

" Convert Ruby 1.8 hash syntax to Ruby 1.9 syntax
" based on https://github.com/henrik/dotfiles/blob/master/vim/config/commands.vim#L20
command! -bar -range=% NotRocket execute '<line1>,<line2>s/:\(\w\+\)\s*=>/\1:/e' . (&gdefault ? '' : 'g')

" highlight rspec keywords properly https://gist.github.com/64635
autocmd BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_should_behave_like before after setup subject its shared_examples_for shared_context let
highlight def link rubyRspec Function

command! -narg=0 FormattingXML :silent exe '%!xmllint --format -'
command! -narg=0 FormattingHTML :silent exe '%! tidy -config ~/.vim/ftplugin/tidyrc_html.txt'
command! -narg=0 FormattingJS :call g:Jsbeautify()<cr>

" map markdown preview
map <leader>m :!open -a "Marked 2" %<cr><cr>
