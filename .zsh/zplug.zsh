################################
# zplug
################################
zplug "~/.zsh", from:local, use:"<->_*.zsh"

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "arks22/tmuximum", \
      as:command, \
      use:"tmuximum", \
      rename-to:"t"

zplug "motemen/ghq", \
      as:command, \
      from:gh-r, \
      rename-to:ghq

zplug "junegunn/fzf", \
      as:command, \
      use:"bin/fzf", \
      rename-to:"fzf", \
      hook-build:"./install --key-bindings --completion --no-update-rc --no-bash --no-fish --64"

zplug "github/hub", \
      from:gh-r, \
      as:command, \
      rename-to:"hub", \
      hook-build:'mkdir -p $HOME/.zsh/completions && cp $(find . -name hub.zsh_completion) $HOME/.zsh/completions/_hub', \
      hook-load:'eval $(hub alias -s)'

zplug "BurntSushi/ripgrep", \
      from:gh-r, \
      as:command, \
      rename-to:rg

zplug "stedolan/jq", \
      as:command, \
      from:gh-r, \
      rename-to:jq
