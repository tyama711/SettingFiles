has() {
    type "${1:?too few arguments}" &>/dev/null
}

rationalise-dot() {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

autoload -Uz is-at-least


## historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
# bindkey "\\ep" history-beginning-search-backward-end
# bindkey "\\en" history-beginning-search-forward-end


# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete

case "${OSTYPE}" in
    freebsd*|darwin*)
        has gls && alias ls="gls --color" || alias ls="ls -G -w"
        has gdircolors && alias dircolors=gdircolors
        has gsed && alias sed=gsed
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

## デフォルトで emacsclient を使用する
has emacsclient && alias e='emacsclient -nw -a ""'


# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
DIRSTACKSIZE=100
setopt auto_pushd

# compacked complete list display
#
setopt list_packed

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep

## Command history configuration
#
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data


if [[ -t 0 ]]; then
    # Disable Ctrl+D
    stty eof undef

    # Disable Ctrl+S
    stty stop undef

    # Disable Ctrl+Q
    stty start undef
fi


if ( ! is-at-least 5.1 ); then
    function git_info() {
        if git_status=$(cd $1 && git status 2>/dev/null ); then
            git_branch="$(echo $git_status| awk 'NR==1 {print $3}')"
            state=""

            if [[ $git_status =~ ".*Your branch is ahead.*" ]]; then
                state="$state!"
            fi
            if [[ $git_status =~ ".*Changes to be committed.*" ]]; then
                state="$state?"
            fi
            if [[ $git_status =~ ".*Changes not staged.*" ]]; then
                state="$state+"
            fi
            if [[ $state = "" ]]; then
                state="✔"
            fi
            if [[ $git_branch = "master" ]]; then
                git_info=" [${git_branch}%{${fg[green]}%}${state}%{${fg[cyan]}%}]"
            else
                git_info=" [${git_branch}%{${fg[green]}%}${state}%{${fg[cyan]}%}]"
            fi
        else
            git_info=""
        fi

        echo $git_info
        return
    }

    autoload -Uz colors && colors

    # set prompt
    #
    setopt promptsubst
    case ${UID} in
        0)
            PROMPT="%{${fg[cyan]}%}\$? $(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %c\$(git_info .) %B%{${fg[red]}%}%#%{${reset_color}%}%b "
            PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
            SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
            ;;
        *)
            PROMPT="%{${fg[cyan]}%}\$? %c\$(git_info .) %{${fg[red]}%}%#%{${reset_color}%} "
            PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
            SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
            [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
                PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
            ;;
    esac
fi


########################################
# tmux の設定
# 自動ロギング
if [[ $TERM = screen ]] || [[ $TERM = screen-256color ]] ; then
    local LOGDIR=$HOME/tmux_logs
    local LOGFILE=$(hostname)_$(date +%Y-%m-%d_%H%M%S_%N.log)
    local FILECOUNT=0
    local MAXFILECOUNT=500 #ここを好きな保存ファイル数に変える。
    # zsh 起動時に自動で$MAXFILECOUNT のファイル数以上ログファイルあれば消す
    find $HOME/tmux_logs/ -maxdepth 1 -type f -name "*.log" | sort --reverse | sed "1,${MAXFILECOUNT}d" | xargs -I % rm -f %
    [ ! -d $LOGDIR ] && mkdir -p $LOGDIR
    tmux  set-option default-terminal "screen" \; \
    pipe-pane        "cat >> $LOGDIR/$LOGFILE" \; \
    display-message  "Started logging to $LOGDIR/$LOGFILE"
fi

# 1. tmux 内で ssh した場合に windows 名を接続先ホスト名に変更する
# 2. ssh の代わりに sshrc コマンドを使用する。
has sshrc && \
    function ssh() {
        if [[ -n "${TMUX}" ]]; then
            tmux rename-window ${${${@: -1}##*@}%%.*}
            command sshrc "$@"
            tmux set-window-option automatic-rename "on" 1>/dev/null
        else
            command sshrc "$@"
        fi
    }

# tmux attach した際に Agent 転送を使えるようにする設定
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

if [[ -n "${TMUX}" ]]; then
    export TERM=screen-256color
fi


###############################
# zplug
###############################
if [[ -f ~/.zplug/init.zsh ]]; then
    export ZPLUG_LOADFILE=~/.zsh/zplug.zsh
    source ~/.zplug/init.zsh

    # if ! zplug check --verbose; then
    #     printf "Install? [y/N]: "
    #     if read -q; then
    #         echo; zplug install
    #     fi
    #     echo
    # fi
    zplug load

    #################################
    # post load configuration
    #################################
    eval "$(hub alias -s)"
    eval "$(fasd --init auto)"
fi

if [[ -n "${REMOTEHOST}${SSH_CONNECTION}" && -z "${TMUX}" ]]; then
    has tmuximum && tmuximum && exit
fi


###############################
# load local configuration
###############################
[ -f ${HOME}/.zshrc.local ] && source ${HOME}/.zshrc.local

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
