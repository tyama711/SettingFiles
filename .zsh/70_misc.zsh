function git_info() {
    if git_status=$(cd $1 && git status 2>/dev/null ); then
        git_branch="$(echo $git_status| awk 'NR==1 {print $3}')"
        state=""

        if [[ $git_status =~ ".*Your branch is ahead.*" ]]; then
            state="$state!"
        fi
        if [[ $git_status =~ ".*Changes to be committed.*" ]]; then
            state="$state?"
        fi
        if [[ $git_status =~ ".*Changes not staged.*" ]]; then
            state="$state+"
        fi
        if [[ $state = "" ]]; then
            state="✔"
        fi
        if [[ $git_branch = "master" ]]; then
            git_info=" [${git_branch}%{${fg[green]}%}${state}%{${fg[cyan]}%}]"
        else
            git_info=" [${git_branch}%{${fg[green]}%}${state}%{${fg[cyan]}%}]"
        fi
    else
        git_info=""
    fi

    echo $git_info
    return
}

# set prompt
#
setopt promptsubst
case ${UID} in
    0)
        PROMPT="%{${fg[cyan]}%}\$? $(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %c\$(git_info .) %B%{${fg[red]}%}%#%{${reset_color}%}%b "
        PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
        SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
        ;;
    *)
        PROMPT="%{${fg[cyan]}%}\$? %c\$(git_info .) %{${fg[red]}%}%#%{${reset_color}%} "
        PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
        SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
        [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
            PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
        ;;
esac


autoload -Uz colors && colors

## Completion configuration
#
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

compdef gh=ghq
compdef g=git

## zsh editor
#
autoload zed

if [[ -t 0 ]]; then
    # Disable Ctrl+D
    stty eof undef

    # Disable Ctrl+S
    stty stop undef

    # Disable Ctrl+Q
    stty start undef
fi

[ -f $HOME/.fzf.zsh ] && source ~/.fzf.zsh
