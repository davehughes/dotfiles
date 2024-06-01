function source-env {
  local from_dir=${1:-$PWD}
  local activate_file="$(bb venv-find-activate-script ${from_dir})"
  if [[ -f $activate_file ]]; then
    echo "Sourcing ${activate_file}"
    source $activate_file
  else
    echo "No virtualenv found"
  fi
}
