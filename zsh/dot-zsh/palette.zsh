# Print the current color palette
function palette {
    COLORS=()
    for color in {000..255}; do
        COLORS+=("$FG[$color] ■ $color")
    done
    echo "${(j:\n:)COLORS}%{$reset_color%}"
}

