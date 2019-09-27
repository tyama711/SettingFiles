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

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
# expressly specify to use fzf
zstyle ":anyframe:selector:" use fzf
# specify path and options for peco, percol, or fzf
zstyle ":anyframe:selector:fzf:" command 'fzf --extended'
zplug "mollifier/anyframe"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
zplug "zsh-users/zsh-autosuggestions"

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

if ( is-at-least 5.1 ); then
    zplug "romkatv/powerlevel10k", as:theme
fi

zplug "seebi/dircolors-solarized", \
      hook-build:"dircolors -b dircolors.256dark > c.zsh", \
      use:"c.zsh"
