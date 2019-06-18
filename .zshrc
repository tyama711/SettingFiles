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

setopt promptsubst
case ${UID} in
    0)
        PROMPT="%{${fg[cyan]}%}\$? $(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %B%{${fg[red]}%}%/#%{${reset_color}%}%b "
        PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
        SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
        ;;
    *)
        PROMPT="%{${fg[cyan]}%}\$? %{${fg[red]}%}%/%%%{${reset_color}%} "
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

export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';

## load user .zshrc configuration file
#
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine

## Macの場合はgsedを使用する
[ $(uname) = Darwin ] && which gsed > /dev/null && alias sed='gsed'

## デフォルトでemacsclientを使用する
which emacsclient > /dev/null && alias emacs='emacsclient -nw -a ""'

[ -d $HOME/.cask ] && export  PATH=$HOME/.cask/bin:$PATH
[ -d $HOME/miniconda3 ] && export PATH=$HOME/miniconda3/bin:$PATH


# NVMの設定
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


##
alias less='less -R'


# command-line fuzzy finder
# https://github.com/junegunn/fzf
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh



################################
# zplug
###############################
if [ -e "$HOME/.zplug/init.zsh" ]; then
    source $HOME/.zplug/init.zsh

    # use tmuximum
    zplug "arks22/tmuximum", as:command

    zplug load
fi


########################################
# tmuxの設定
# 自動ロギング
if [[ $TERM = screen ]] || [[ $TERM = screen-256color ]] ; then
    local LOGDIR=$HOME/tmux_logs
    local LOGFILE=$(hostname)_$(date +%Y-%m-%d_%H%M%S_%N.log)
    local FILECOUNT=0
    local MAXFILECOUNT=500 #ここを好きな保存ファイル数に変える。
    # zsh起動時に自動で$MAXFILECOUNTのファイル数以上ログファイルあれば消す
    find $HOME/tmux_logs/ -maxdepth 1 -type f -name "*.log" | sort --reverse | sed "1,${MAXFILECOUNT}d" | xargs -I % rm -f %
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
type sshrc >/dev/null 2>&1 && \
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
            PROMPT="%{${fg[cyan]}%}\$? \$(date +%H:%M:%S) %{${fg[red]}%}%%%{${reset_color}%} "
            ;;
    esac
fi

# tmuximumの自動起動
type tmuximum >/dev/null 2>&1 && \
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
        alias t="tmuximum"
        if [ -z $TMUX ]; then
            tmuximum && exit
        fi
    fi

