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
FZF_DEFAULT_OPTS="--exact --preview 'head -100 {}'"

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

zplug "mrowa44/emojify", as:command, use:emojify
zplug "b4b4r07/emoji-cli"

zplug "rupa/z", as:command
zplug "changyuheng/fz", defer:1

zplug "shannonmoeller/up", use:"up.sh"
zplug "ogham/exa", as:command, from:"gh-r", rename-to:exa
zplug "sharkdp/bat", as:command, from:"gh-r", use:"*x86_64*linux*musl*"
zplug "sharkdp/fd", as:command, from:"gh-r", use:"*x86_64*linux*musl*"
zplug "raylee/tldr", as:command
zplug "knqyf263/pet", as:command, from:"gh-r", use:"*linux*amd64*tar.gz"

zplug "so-fancy/diff-so-fancy", as:command, \
      use:"third_party/build_fatpack/diff-so-fancy", rename-to:diff-so-fancy
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
