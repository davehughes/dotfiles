SYSTEM_ZSHRC_PATH=/etc/zshrc
read -r -d '' NIX_DAEMON_LOAD_SCRIPT <<"EOF"
# Nix daemon load
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
EOF

if [ "$(cat $SYSTEM_ZSHRC_PATH | grep "# Nix daemon load" | wc -l)" -eq "0" ]; then
  echo $NIX_DAEMON_LOAD_SCRIPT >> $SYSTEM_ZSHRC_PATH
fi
