add_to_PATH /opt/homebrew/bin:/opt/homebrew/sbin

function -homebrew-install() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
