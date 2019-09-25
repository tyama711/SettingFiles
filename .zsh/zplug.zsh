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

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
zplug "zsh-users/zsh-autosuggestions"

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

if [[ $ZSH_MAJOR_VERSION -gt 5 || ( $ZSH_MAJOR_VERSION -ge 5 && $ZSH_MINOR_VERSION -ge 1 ) ]]; then
    zplug "romkatv/powerlevel10k", as:theme
fi

zplug "seebi/dircolors-solarized", \
      hook-build:"dircolors -b dircolors.256dark > c.zsh", \
      use:"c.zsh"
