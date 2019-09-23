# zmodload zsh/zprof && zprof
if [ -z ${TMUX} ]; then
    tmux && exit 0
fi

## Tmux auto logging
if [[ ! -z "$TMUX" ]]; then
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

    export TERM=screen-256color
fi

has() {
    type "${1:?too few arguments}" &>/dev/null
}

# ... -> ../../, .... -> ../../../ and so on.
rationalise-dot() {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi

}
zle -N rationalise-dot
bindkey . rationalise-dot

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"
alias du="du -h"
alias df="df -h"
alias su="su -l"
alias less='less -R'
alias ls="ls --color"

# Macの場合はgsedを使用する
[ $(uname) = Darwin ] && has gsed && alias sed='gsed'

# デフォルトでemacsclientを使用する
has emacsclient && alias e='emacsclient -nw -a ""'

# auto change directory
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
DIRSTACKSIZE=100
setopt auto_pushd

# compacked complete list display
setopt list_packed

# no remove postfix slash of command line
setopt noautoremoveslash

# no beep sound when complete list displayed
setopt nolistbeep

# Command history configuration
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

# Disable terminal shortcut keys
if [[ -t 0 ]]; then
    # Disable Ctrl+D
    stty eof undef

    # Disable Ctrl+S
    stty stop undef

    # Disable Ctrl+Q
    stty start undef
fi

### Zplugin configuration
### Added by Zplugin's installer
source '/home/tyama711/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

## program section
zplugin ice from"gh-r" as"program" pick"ghq*/ghq"
zplugin light motemen/ghq

zplugin ice as"program" \
        atclone"./install --key-bindings --completion --no-update-rc --no-bash --no-fish --64" \
        atpull"%atclone" atload"[ -f $HOME/.fzf.zsh ] && source ~/.fzf.zsh" pick"bin/fzf"
zplugin light junegunn/fzf

zplugin ice from"gh-r" as"program" atload'eval "$(hub alias -s)"' pick"hub*/bin/hub"
zplugin light github/hub

zplugin ice from"gh-r" as"program" pick"ripgrep*/rg"
zplugin light BurntSushi/ripgrep

zplugin ice from"gh-r" as"program" mv"jq* -> jq" pick"jq"
zplugin light stedolan/jq

## completion section
zplugin ice wait from"gh-r" as"completion" id-as"hub_completion" \
        mv"hub*/etc/hub.zsh_completion -> _hub" pick"_hub"
zplugin light github/hub

## plugin section
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zplugin light romkatv/powerlevel10k

zplugin ice wait atclone"dircolors -b dircolors.256dark > c.zsh" \
        atpull'%atclone' pick"c.zsh" nocompile'!'
zplugin snippet https://github.com/seebi/dircolors-solarized/blob/master/dircolors.256dark

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
zplugin ice wait atload'_zsh_autosuggest_start'
zplugin light zsh-users/zsh-autosuggestions

zplugin ice wait
zplugin light zsh-users/zsh-syntax-highlighting

### End of Zplugin configuration

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

[[ -f ${HOME}/.zshrc.local ]] && source ${HOME}/.zshrc.local

# if (which zprof > /dev/null) ;then
#     zprof | less
# fi
