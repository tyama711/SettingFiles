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

if [ $(uname) = Darwin ]; then
    zplug "junegunn/fzf-bin", \
          from:gh-r, \
          as:command, \
          rename-to:f, \
          use:"*darwin*amd64*"

    zplug "BurntSushi/ripgrep", \
          from:gh-r, \
          as:command, \
          rename-to:rg, \
          use:"*darwin*"
else
    zplug "junegunn/fzf-bin", \
          from:gh-r, \
          as:command, \
          rename-to:f, \
          use:"*linux*amd64*"

    zplug "BurntSushi/ripgrep", \
          from:gh-r, \
          as:command, \
          rename-to:rg, \
          use:"*x86_64*linux*"
fi

# zplug "b4b4r07/enhancd", \
    #       use:init.sh
# export ENHANCD_FILTER=fzf
# export ENHANCD_DISABLE_HYPHEN=1
# export ENHANCD_DOT_ARG=...

