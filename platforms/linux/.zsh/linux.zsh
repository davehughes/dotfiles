alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# Map CapsLock to trigger F4, which is the tmux Leader
xmodmap -e "keycode 66 = F4"
xmodmap -e "clear Lock"
