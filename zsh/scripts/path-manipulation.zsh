# Add segments to PATH idempotently
add_to_PATH () {
  append_to_PATH $@
}

append_to_PATH () {
  for d; do
    d=$({ cd -- "$d" && { pwd -P || pwd; } } 2>/dev/null)  # canonicalize symbolic links
    if [ -z "$d" ]; then continue; fi  # skip nonexistent directory
    case ":$PATH:" in
      *":$d:"*) :;;
      *) PATH=$PATH:$d;;
    esac
  done
}

prepend_to_PATH () {
  for d; do
    d=$({ cd -- "$d" && { pwd -P || pwd; } } 2>/dev/null)  # canonicalize symbolic links
    if [ -z "$d" ]; then continue; fi  # skip nonexistent directory
    case ":$PATH:" in
      *":$d:"*) :;;
      *) PATH=$d:$PATH;;
    esac
  done
}
