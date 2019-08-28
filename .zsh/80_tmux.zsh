########################################
# tmuxの設定
# 自動ロギング
if [[ $TERM = screen ]] || [[ $TERM = screen-256color ]] ; then
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
fi


# 1. tmux内でsshした場合にwindows名を接続先ホスト名に変更する
# 2. sshの代わりにsshrcコマンドを使用する。
has sshrc && \
    function ssh() {
        if [ ! -z $TMUX ]; then
            tmux rename-window ${${${@: -1}##*@}%%.*}
            command sshrc "$@"
            tmux set-window-option automatic-rename "on" 1>/dev/null
        else
            command sshrc "$@"
        fi
    }


# tmux attachした際にAgent転送を使えるようにする設定
# https://qiita.com/sonots/items/2d7950a68da0a02ba7e4
agent="$HOME/.ssh/agent"
if [ -S "$SSH_AUTH_SOCK" ]; then
    case $SSH_AUTH_SOCK in
    /tmp/*/agent.[0-9]*)
        ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
    esac
elif [ -S $agent ]; then
    export SSH_AUTH_SOCK=$agent
else
    echo "no ssh-agent"
fi

# # tmuxの場合はプロンプトにパスを表示しない
# if [ ! -z $TMUX ]; then
#     case ${UID} in
#         *)
#             PROMPT="%{${fg[cyan]}%}\$? %c %{${fg[red]}%}%#%{${reset_color}%} "
#             [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
#                 PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
#             ;;
#     esac
# fi

# tmuxで新規ペインを開いたときになぜか.tmux.confの
# default-terminalの設定が効かないので、ここで明示的に設定する
if [ ! -x $TMUX ]; then
    export TERM=screen-256color
fi
