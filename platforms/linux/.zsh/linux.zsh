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
