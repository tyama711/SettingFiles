################################
# zplug
###############################
if [[ -f ~/.zplug/init.zsh ]]; then
    export ZPLUG_LOADFILE=~/.zsh/zplug.zsh
    source ~/.zplug/init.zsh

    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
        echo
    fi
    zplug load

    #################################
    # post load configuration
    #################################
    eval $(hub alias -s)
fi


###############################
# load local configuration
###############################
[ -f ${HOME}/.zshrc.local ] && source ${HOME}/.zshrc.local

# tmuximumの自動起動
type tmuximum >/dev/null 2>&1 && \
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" -a -z $TMUX ]; then
        tmuximum && exit
    fi

