# users generic .zshrc file for zsh(1)

## Environment variable configuration
#
# LANG
#
export LANG=ja_JP.UTF-8
case ${UID} in
0)
    LANG=C
    ;;
esac


## Default shell configuration
#
# set prompt
#
autoload colors
colors

case ${UID} in
    0)
        PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %B%{${fg[red]}%}%/#%{${reset_color}%}%b "
        PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
        SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
        ;;
    *)
        PROMPT="%{${fg[red]}%}%/%%%{${reset_color}%} "
        PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
        SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
        [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
            PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
        ;;
esac

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep


## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a gets to line head and Ctrl-e gets
#   to end) and something additions
#
bindkey -e
bindkey "^[[1~" beginning-of-line # Home gets to line head
bindkey "^[[4~" end-of-line # End gets to line end
bindkey "^[[3~" delete-char # Del

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete


## Command history configuration
#
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data


## Completion configuration
#
fpath=(${HOME}/.zsh/functions/Completion ${fpath})

DIRSTACKSIZE=100
setopt AUTO_PUSHD

autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'


## zsh editor
#
autoload zed


## Prediction configuration
#
#autoload predict-on
#predict-off


## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases     # aliased ls needs if file/dir completions work

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


# ## terminal configuration
# #
# case "${TERM}" in
# screen)
#     TERM=xterm
#     ;;
# esac

# case "${TERM}" in
# xterm|xterm-color)
#     export LSCOLORS=exfxcxdxbxegedabagacad
#     export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#     zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
#     ;;
# kterm-color)
#     stty erase '^H'
#     export LSCOLORS=exfxcxdxbxegedabagacad
#     export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#     zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
#     ;;
# kterm)
#     stty erase '^H'
#     ;;
# cons25)
#     unset LANG
#     export LSCOLORS=ExFxCxdxBxegedabagacad
#     export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#     zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
#     ;;
# jfbterm-color)
#     export LSCOLORS=gxFxCxdxBxegedabagacad
#     export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#     zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
#     ;;
# esac

# # set terminal title including current directory
# #
# case "${TERM}" in
# xterm|xterm-color|kterm|kterm-color)
#     precmd() {
#         echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
#     }
#     ;;
# esac




## load user .zshrc configuration file
#
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine

## Macの場合はgsedを使用する
[ $(uname) = Darwin ] && which gsed > /dev/null && alias sed='gsed'

## デフォルトでemacsclientを使用する
which emacsclient > /dev/null && alias emacs='emacsclient -nw -a ""'

[ -d $HOME/.cask ] && export  PATH=/home/takuyaya/.cask/bin:$PATH
[ -d $HOME/miniconda3 ] && export PATH=/home/takuyaya/miniconda3/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

##
alias less='less -R'


# command-line fuzzy finder
# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh



################################
# zplug
###############################
source ~/.zplug/init.zsh

# use tmuximum
zplug "arks22/tmuximum", as:command

zplug load



########################################
# tmuxの設定
# 自動ロギング
if [[ $TERM = screen ]] || [[ $TERM = screen-256color ]] ; then
    local LOGDIR=$HOME/tmux_logs
    local LOGFILE=$(hostname)_$(date +%Y-%m-%d_%H%M%S_%N.log)
    local FILECOUNT=0
    local MAXFILECOUNT=500 #ここを好きな保存ファイル数に変える。
    # zsh起動時に自動で$MAXFILECOUNTのファイル数以上ログファイルあれば消す
    for file in `\find "$LOGDIR" -maxdepth 1 -type f -name "*.log" | sort --reverse`; do
        FILECOUNT=`expr $FILECOUNT + 1`
        if [ $FILECOUNT -ge $MAXFILECOUNT ]; then
            rm -f $file
        fi
    done
    [ ! -d $LOGDIR ] && mkdir -p $LOGDIR
    tmux  set-option default-terminal "screen" \; \
    pipe-pane        "cat >> $LOGDIR/$LOGFILE" \; \
    display-message  "Started logging to $LOGDIR/$LOGFILE"
fi

# # https://qiita.com/arks22/items/db8eb6a14223ce29219a
# function precmd() {
#     if [ ! -z $TMUX ]; then
#         tmux refresh-client -S
#     fi
# }

# 1. tmux内でsshした場合にwindows名を接続先ホスト名に変更する
# 2. sshの代わりにsshrcコマンドを使用する。
function ssh() {
    if [ ! -z $TMUX ]; then
        tmux rename-window ${${${@: -1}##*@}%%.*}
        command sshrc "$@"
        tmux set-window-option automatic-rename "on" 1>/dev/null
    else
        command sshrc "$@"
    fi
}

# tmux attachした際にAgent転送を使えるようにする設定
# https://qiita.com/sonots/items/2d7950a68da0a02ba7e4
agent="$HOME/.ssh/agent"
if [ -S "$SSH_AUTH_SOCK" ]; then
    case $SSH_AUTH_SOCK in
    /tmp/*/agent.[0-9]*)
        ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
    esac
elif [ -S $agent ]; then
    export SSH_AUTH_SOCK=$agent
else
    echo "no ssh-agent"
fi

# tmuxの場合はプロンプトにパスを表示しない
if [ ! -z $TMUX ]; then
    case ${UID} in
        *)
            setopt promptsubst
            PROMPT="%{${fg[cyan]}%}\$? %{${fg[red]}%}%%%{${reset_color}%} "
            [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
                PROMPT="${PROMPT}"
            ;;
    esac
fi

# tmuximumの自動起動
alias t="tmuximum"
if [ -z $TMUX ]; then
    tmuximum && exit
fi
