alias where="command -v"
alias j="jobs -l"

case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G -w"
    ;;
linux*)
    alias ls="ls --color"
    ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

alias du="du -h"
alias df="df -h"

alias su="su -l"

alias less='less -R'

## Macの場合はgsedを使用する
[ $(uname) = Darwin ] && has gsed && alias sed='gsed'

## デフォルトでemacsclientを使用する
has emacsclient && alias e='emacsclient -nw -a ""'

# ghqはうちにくい
has ghq && alias gh=ghq
has git && alias g=git

