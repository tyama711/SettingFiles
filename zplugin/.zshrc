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

autoload -Uz compinit && compinit

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
alias less='less -r'
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
    stty eof undef   # Disable Ctrl+D
    stty stop undef  # Disable Ctrl+S
    stty start undef # Disable Ctrl+Q
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
        atpull"%atclone" \
        atload"[ -f $HOME/.fzf.zsh ] && source ~/.fzf.zsh" pick"bin/fzf"
zplugin light junegunn/fzf
FZF_DEFAULT_OPTS="--exact --preview 'head -100 {}'"

zplugin ice from"gh-r" as"program" atload'eval "$(hub alias -s)"' \
        pick"hub*/bin/hub"
zplugin light github/hub

zplugin ice from"gh-r" as"program" pick"ripgrep*/rg"
zplugin light BurntSushi/ripgrep

zplugin ice from"gh-r" as"program" mv"jq* -> jq" pick"jq"
zplugin light stedolan/jq

zplugin ice from"gh-r" as"program" pick"fd*/fd"
zplugin light sharkdp/fd

zplugin ice from"gh-r" as"program" mv"exa*->exa" pick"exa"
zplugin light ogham/exa

zplugin ice from"gh-r" as"program" pick"bat*/bat"
zplugin light sharkdp/bat

zplugin ice as"program" pick"tldr"
zplugin light raylee/tldr

zplugin ice as"program" from"gh-r" bpick"*.tar.gz" pick"pet"
zplugin light knqyf263/pet

zplugin ice as"program" pick"bin/anyenv" atclone"bin/anyenv init" \
        atpull"%atclone" atload'eval "$(anyenv init -)"'
zplugin light anyenv/anyenv

zplugin ice as"program" from"gh-r" mv"direnv*->direnv" pick"direnv"
zplugin light direnv/direnv
eval "$(direnv hook zsh)"

zplugin ice as"program" pick"third_party/build_fatpack/diff-so-fancy"
zplugin light so-fancy/diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global color.ui true
git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"
git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"

zplugin ice as"program" atclone"./autogen.sh && ./configure && make" \
        atpull"%atclone" pick"htop"
zplugin light hishamhm/htop

## completion section
zplugin ice wait from"gh-r" as"completion" id-as"hub_completion" \
        mv"hub*/etc/hub.zsh_completion -> _hub" pick"_hub"
zplugin light github/hub

zplugin ice wait as"completion" id-as"exa_completion" \
        mv"contrib/completions.zsh->_exa" pick"_exa"
zplugin light ogham/exa

## plugin section
zplugin ice wait atload"source up.sh"
zplugin light shannonmoeller/up

zplugin ice wait
zplugin light rupa/z

zplugin ice wait
zplugin light changyuheng/fz

zplugin ice wait
zplugin light mollifier/anyframe

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

bindkey '^xb' anyframe-widget-cdr
bindkey '^x^b' anyframe-widget-checkout-git-branch
bindkey '^xr' anyframe-widget-execute-history
bindkey '^x^r' anyframe-widget-execute-history
bindkey '^xi' anyframe-widget-put-history
bindkey '^x^i' anyframe-widget-put-history
bindkey '^xg' anyframe-widget-cd-ghq-repository
bindkey '^x^g' anyframe-widget-cd-ghq-repository
bindkey '^xk' anyframe-widget-kill
bindkey '^x^k' anyframe-widget-kill
bindkey '^xe' anyframe-widget-insert-git-branch
bindkey '^x^e' anyframe-widget-insert-git-branch

# expressly specify to use fzf
zstyle ":anyframe:selector:" use fzf
# specify path and options for peco, percol, or fzf
zstyle ":anyframe:selector:fzf:" command 'fzf --extended'

# zplugin ice wait
zplugin light zsh-users/zsh-completions

zplugin light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

zplugin ice wait atclone"dircolors -b dircolors.256dark > c.zsh" \
        atpull'%atclone' pick"c.zsh" nocompile'!'
zplugin snippet https://github.com/seebi/dircolors-solarized/blob/master/dircolors.256dark

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
zplugin ice wait atload'_zsh_autosuggest_start'
zplugin light zsh-users/zsh-autosuggestions

zplugin ice wait"1" atinit"zpcompinit"
zplugin light zsh-users/zsh-syntax-highlighting

zplugin ice wait"2" \
        atload'bindkey "^[p" history-substring-search-up' \
        atload'bindkey "^[n" history-substring-search-down'
zplugin light zsh-users/zsh-history-substring-search
### End of Zplugin configuration

[[ -f ${HOME}/.zshrc.local ]] && source ${HOME}/.zshrc.local

# if (which zprof > /dev/null) ;then
#     zprof | less
# fi
