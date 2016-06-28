# Remap caps lock so it can be used as the tmux prefix key (see .tmux.conf)

function decap {
    setxkbmap
    if [[ "$1" == "1" || "$1" == "true" ]]; then; xdotool key Caps_Lock; fi
    xmodmap -e "remove Lock = Caps_Lock" >/dev/null 2>&1
    xmodmap -e "keysym Caps_Lock = Prior" >/dev/null 2>&1
}

function DECAP {
    decap true
}
