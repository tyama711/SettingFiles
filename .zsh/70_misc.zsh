# set prompt
#
setopt promptsubst
case ${UID} in
    0)
        PROMPT="%{${fg[cyan]}%}\$? $(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %c %B%{${fg[red]}%}%#%{${reset_color}%}%b "
        PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
        SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
        ;;
    *)
        PROMPT="%{${fg[cyan]}%}\$? %c %{${fg[red]}%}%#%{${reset_color}%} "
        PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
        SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
        [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
            PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
        ;;
esac


autoload -Uz colors && colors

## Completion configuration
#
autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'


## zsh editor
#
autoload zed



## Macの場合はgsedを使用する
[ $(uname) = Darwin ] && has gsed > /dev/null && alias sed='gsed'

## デフォルトでemacsclientを使用する
has emacsclient && alias emacs='emacsclient -nw -a ""'

# CaskへPathを通す
[ -d $HOME/.cask ] && export  PATH=$HOME/.cask/bin:$PATH

