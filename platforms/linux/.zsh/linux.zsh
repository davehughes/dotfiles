export PATH=$PATH:$HOME/.local/bin

function -setup-keyboard {
    # When using a linux desktop instance, set up some utilities
    if [ -n "${DISPLAY}" ]; then
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'

        # Map CapsLock to trigger F4, which is the tmux Leader
        -set-capslock off
        xmodmap -e "keycode 66=F4"
        xmodmap -e "clear Lock"

        # Map Fn -> Ctrl for Apple keyboards
        xmodmap -e "keycode 464=Control_L"

        # Set keyboard repeat rate
        xset r rate 200 80
    else
        alias pbcopy='echo "No clipboard available in headless session"'
        alias pbpaste='echo "No clipboard available in headless session"'
    fi
}

# Remap caps lock so it can be used as the tmux prefix key (see .tmux.conf)
alias decap="-set-capslock off"
alias DECAP=decap

function -capslock-state {
    xset q | ag "Caps Lock" | sed 's/^.*00:\s*Caps Lock:\s*\(off\|on\).*$/\1/'
}

function -toggle-capslock {
    -set-capslock $(-invert-on-off-state $(-capslock-state))
}

function -invert-on-off-state {
    STATE=$1
    if [[ "$STATE" = "off" ]]; then
        echo "on"
    elif [[ "$STATE" = "on" ]]; then
        echo "off"
    else
        echo "off"
    fi
}

function -set-capslock {
    TARGET_STATE=$1
    STATE=$(-capslock-state)
    if [[ "$STATE" = "$TARGET_STATE" ]]; then
        echo "CapsLock is in target state ($TARGET_STATE)"
    elif [[ "$TARGET_STATE" = "off" ]]; then
        echo "CapsLock changed from ON -> OFF"
        xdotool key Caps_Lock
    elif [[ "$TARGET_STATE" = "on" ]]; then
        echo "CapsLock changed from OFF -> ON"
        xdotool key Caps_Lock
    else
        echo "Unrecognized target state"
    fi
}

# Configure system settings without dconf UI
function -gnome-configure {
    # Workspace matrix extension settings
    NAMESPACE="org.gnome.shell.extensions.wsmatrix"
    SCHEMADIR="${HOME}/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas"
    gsettings --schemadir ${SCHEMADIR} reset-recursively ${NAMESPACE}
    gsettings --schemadir ${SCHEMADIR} set ${NAMESPACE} num-rows 3
    gsettings --schemadir ${SCHEMADIR} set ${NAMESPACE} num-columns 3
    gsettings --schemadir ${SCHEMADIR} set ${NAMESPACE} cache-popup true
    gsettings --schemadir ${SCHEMADIR} set ${NAMESPACE} popup-timeout 300
    gsettings --schemadir ${SCHEMADIR} set ${NAMESPACE} scale 0.15
}

function -gnome-keys-laptop {
    gsettings reset-recursively org.gnome.desktop.wm.keybindings

    gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
    gsettings set org.gnome.shell.window-switcher current-workspace-only false

    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Control><Alt><Super>h']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Control><Alt><Super>j']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Control><Alt><Super>k']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Control><Alt><Super>l']"

    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Control><Alt>h']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Control><Alt>j']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Control><Alt>k']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Control><Alt>l']"

    gsettings set org.gnome.desktop.wm.keybindings move-to-side-w "['<Alt>h']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-s "['<Alt>j']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-n "['<Alt>k']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-e "['<Alt>l']"
}

function -gnome-keys-magic-keyboard {
    gsettings reset-recursively org.gnome.desktop.wm.keybindings

    gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Super>Tab']"
    gsettings set org.gnome.shell.window-switcher current-workspace-only false

    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Control><Alt><Super>h']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Control><Alt><Super>j']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Control><Alt><Super>k']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Control><Alt><Super>l']"

    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Control><Super>h']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Control><Super>j']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Control><Super>k']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Control><Super>l']"

    gsettings set org.gnome.desktop.wm.keybindings move-to-side-w "['<Alt>h']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-s "['<Alt>j']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-n "['<Alt>k']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-e "['<Alt>l']"
}

# Reset network driver on piece-of-shit XPS13
function -renet {
    # echo "Power cycling network driver (ath10k_pci)"
    # sudo modprobe -r ath10k_pci
    # sudo modprobe ath10k_pci
    # echo "Wait 30-90 seconds for this to take effect..."

    # From https://ubuntuforums.org/showthread.php?t=2384252
    echo "Rescanning PCI bus"
    echo 1 | sudo tee /sys/bus/pci/rescan >> /dev/null

    # Other things to try/look at:
    # > sudo lshw -class network
    # > lspci
    # > lsmod
    # > dmesg
}

-setup-keyboard
