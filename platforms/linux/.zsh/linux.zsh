export PATH=$PATH:$HOME/.local/bin

# When using a linux desktop instance, set up some utilities
if [ -n "${DISPLAY}" ]; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'

    # Map CapsLock to trigger F4, which is the tmux Leader
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

# Configure system settings without dconf UI
function -gnome-configure {
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
