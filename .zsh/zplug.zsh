################################
# zplug
################################

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "motemen/ghq", \
      as:command, \
      from:gh-r, \
      rename-to:ghq

zplug "junegunn/fzf", \
      as:command, \
      use:"bin/fzf", \
      rename-to:"fzf", \
      hook-build:"./install --key-bindings --completion --no-update-rc --no-bash --no-fish --64", \
      hook-load:"[ -f $HOME/.fzf.zsh ] && source ~/.fzf.zsh"
FZF_DEFAULT_OPTS="--exact"

zplug "github/hub", \
      from:gh-r, \
      as:command, \
      rename-to:"hub", \
      hook-build:'mkdir -p $HOME/.zsh/completions && cp $(find . -name hub.zsh_completion) $HOME/.zsh/completions/_hub'
export FPATH="${HOME}/.zsh/completions:${FPATH}"

zplug "BurntSushi/ripgrep", \
      from:gh-r, \
      as:command, \
      rename-to:rg

zplug "stedolan/jq", \
      as:command, \
      from:gh-r, \
      rename-to:jq

zplug "arks22/tmuximum", as:command

zplug "clvv/fasd", as:command, use:fasd

zplug "mrowa44/emojify", as:command, use:emojify

zplug "b4b4r07/emoji-cli"

zplug "mollifier/anyframe"
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
# expressly specify to use fzf
zstyle ":anyframe:selector:" use fzf
# specify path and options for peco, percol, or fzf
zstyle ":anyframe:selector:fzf:" command 'fzf --extended'
bindkey '^xb'  anyframe-widget-cdr
bindkey '^x^b' anyframe-widget-checkout-git-branch
bindkey '^xr'  anyframe-widget-execute-history
bindkey '^x^r' anyframe-widget-execute-history
bindkey '^xi'  anyframe-widget-put-history
bindkey '^x^i' anyframe-widget-put-history
bindkey '^xg'  anyframe-widget-cd-ghq-repository
bindkey '^x^g' anyframe-widget-cd-ghq-repository
bindkey '^xk'  anyframe-widget-kill
bindkey '^x^k' anyframe-widget-kill
bindkey '^xe'  anyframe-widget-insert-git-branch
bindkey '^x^e' anyframe-widget-insert-git-branchfi

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
zplug "zsh-users/zsh-autosuggestions"

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug "zsh-users/zsh-history-substring-search", defer:3
bindkey '^[p' history-substring-search-up
bindkey '^[n' history-substring-search-down

if ( is-at-least 5.1 ); then
    zplug "romkatv/powerlevel10k", as:theme
fi

zplug "seebi/dircolors-solarized", \
      hook-build:"dircolors -b dircolors.256dark > c.zsh", \
      use:"c.zsh"
