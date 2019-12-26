if [[ -f /usr/local/bin/zsh && $(readlink /proc/$$/exe) != /usr/local/bin/zsh ]]; then
    /usr/local/bin/zsh
    exit $?
elif [[ -f ${HOME}/dotfiles/.zshrc_ ]]; then
    source ${HOME}/dotfiles/.zshrc_
fi

if [[ -f ${HOME}/.zshrc.local ]]; then
    source ${HOME}/.zshrc.local
fi
