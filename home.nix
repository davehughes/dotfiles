{ config, pkgs, ... }:

let
  dave-cli = with pkgs.python3Packages; buildPythonPackage {
    name = "dave-cli";
    version = "v0.1";
    format = "pyproject";
    src = pkgs.fetchFromGitHub {
      owner = "davehughes";
      repo = "dave-cli";
      rev = "v0.1";
      sha256 = "UY5WT6YYfg4RD2vnL+czJEO4sIXGujK6l38H8Ti5jLo=";
    };

    propagatedBuildInputs = [ setuptools tabulate pyyaml ];
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dave";
  home.homeDirectory = "/Users/dave";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Install packages in the environment.
  #
  # I've encountered [this issue](https://github.com/NixOS/nix/issues/3616),
  # which seems to be related to OSX upgrades removing PATH entries, and the
  # solution is given in this comment:
  # https://github.com/NixOS/nix/issues/3616#issuecomment-903869569
  home.packages = with pkgs; [
    bash
    babashka
    # TODO: take your pick: vim is -python3, vim-full has +python3 but breaks copy-paste
    # vim-full
    vim

    fasd
    ripgrep
    jq
    yq
    jet
    tree
    ctags
    asdf-vm
    gnupg
    mitmproxy
    pwgen
    oath-toolkit
    rlwrap

    skhd
    yabai
    karabiner-elements

    sqlite
    duckdb
    postgresql
    redis
    iredis
    # snowsql # TODO: 'unfree' package, need to figure out how to set this up

    awscli2
    docker
    docker-compose

    clojure
    racket
    ruby
    rustup
    nodejs

    # browse options at https://www.nerdfonts.com/font-downloads
    (nerdfonts.override {
      fonts = [
      "FantasqueSansMono"
      "Inconsolata"
      "IntelOneMono"
      "SourceCodePro"
      ]; })

    (pkgs.python3.withPackages (p: with p; [dave-cli ipython ipdb]))

    obsidian

    sl
    cowsay

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # NOTE: there's a bootstrapping problem here...
  # home.file.".config/nix/nix.conf".source = nix/nix.conf;
  home.file.".config/nixpkgs/config.nix".source = nixpkgs/config.nix;

  home.sessionVariables = {
    PAGER = "less";

    # Don't rename the terminal, it's likely a tmux window that I already named
    DISABLE_AUTO_TITLE = "true";
    VIRTUAL_ENV_DISABLE_PROMPT = "true";
  };

  home.sessionPath = [
    # python-tools bin directory
    "$HOME/.local/python-tools/bin"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # NOTE: I've seen some weird interactions where tmux settings don't get applied until the tmux server is killed
  # If in doubt, kill all sessions and launch a new one with `tmux new-session`.
  programs.tmux = {
    enable = true;

    terminal = "tmux-256color";
    keyMode = "vi";
    escapeTime = 0;
    historyLimit = 50000;
    disableConfirmationPrompt = true;
    sensibleOnTop = false;

    tmuxp.enable = true;
    plugins = with pkgs; [
      # tmuxPlugins.yank
      tmuxPlugins.nord
      # tmuxPlugins.power-theme
    ];

    extraConfig = ''
      # rebind prefix key
      # (using Karabiner-Elements to send F4 when 'caps lock' is pressed)
      set -g prefix F4
      unbind C-b

      # split windows with mnemonic characters
      unbind %
      bind | split-window -h
      bind - split-window -v

      # hjkl shortcuts for next/previous pane/window
      bind j select-pane -t :.-
      bind k select-pane -t :.+
      bind h previous-window
      bind l next-window

      # C-hjkl pane resizing
      bind-key C-l resize-pane -R 10
      bind-key C-h resize-pane -L 10
      bind-key C-k resize-pane -U 10
      bind-key C-j resize-pane -D 10

      bind a setw synchronize-panes

      # reload tmux config
      bind R source ~/.config/tmux/tmux.conf

      set-window-option -g automatic-rename off
      set -s set-clipboard on
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides "*:Ss=\E[%p1%d q:Se\E[ q"
      set-environment -g COLORTERM "truecolor"

      # get rid of annoying lag when pressing Esc in vims
      set -s escape-time 0
    '';
  };

  home.file.".tmuxp" = { source = ./tmuxp; recursive = true; };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";

    shellAliases = {
      # Always load tmux in 256 color mode
      tmux="tmux -2";
      tmux-layout="tmux display-message -p '#{window_layout}'";

      hm = "home-manager";

      # fasd
      v  = "fasd -fe vim";
      vv = "fasd -fise vim";
      j  = "fasd_cd -d";
      jj = "fasd_cd -d -i";
      l  = "fasd -de ls";
      ll = "fasd -dise ls";

      "/" = "rg";
      "/ps" = "ps ax | rg";
      "/nix" = "nix search nixpkgs";

      ":e" = "$EDITOR";
      ":q" = "exit";

      pg-list = "dave pg-list";
      pg-edit = "$EDITOR ~/.pgpass";
    };

    initExtra = ''
      # apply emacs keymap
      bindkey -e
      unsetopt correct_all
      unsetopt correct
      unsetopt nomatch
      setopt complete_aliases

      # set up fasd
      eval "$(fasd --init auto zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zshwcomp-install)"

      . "$HOME/.nix-profile/share/asdf-vm/asdf.sh"
      . "$HOME/.nix-profile/share/asdf-vm/completions/_asdf"

      fpath=(~/.config/zsh/functions "$fpath[@]")
      autoload -Uz \
        edit-interactive \
        findenv \
        kill-spotify \
        path-append path-prepend path-edit path-ls \
        palette \
        pg-connect \
        snowsql-json
    '';

    # TODO: peruse https://github.com/unixorn/awesome-zsh-plugins and add anything that looks useful
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
      }
    ];
  };
  home.file.".config/zsh/scripts"   = { source = zsh/scripts; recursive = true; };
  home.file.".config/zsh/themes"    = { source = zsh/themes; recursive = true; };
  home.file.".config/zsh/functions" = { source = zsh/functions; recursive = true; };

  programs.kitty = {
    enable = true;
    # use `kitty +kitten themes` to browse
    theme = "Soft Server";
    font = {
      name = "SauceCodePro";
      size = 12;
    };
    settings = {
      enable_audio_bell = false;
      background_opacity = "0.9";
    };
  };

  # starship multi-shell theme builder
  programs.starship = {
    enable = true;
    # some interesting themes to crib from:
    # https://starship.rs/presets/tokyo-night.html
    # https://starship.rs/presets/pastel-powerline.html
    # some useful symbols:                
    settings = {
      add_newline = false;
      # format = "$all";
      format = "[»](fg:#d08770 bold) ";
      continuation_prompt = "։ ";
      right_format = ''
        [](fg:#d08770)
        $directory
        [](bg:#d08770 fg:#81a1c1)
        ($git_branch$git_commit)
        [](bg:#81a1c1 fg:#8fbcbb)
        $rust
        $ruby
        $java
        $python
        $golang
        $nodejs
        ($character)
        [](fg:#8fbcbb)
      '';

      directory = {
        style = "fg:#3b4252 bg:#d08770";
        format = "[›$path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "fg:#3b4252 bg:#81a1c1";
        format = "[$symbol $branch]($style)";
      };

      git_commit = {
        style = "fg:#3b4252 bg:#81a1c1";
        only_detached = false;
        format = "[ \\($hash$tag\\) ]($style)";
      };

      python = {
        style = "fg:#3b4252 bg:#8fbcbb";
        format = "[py$version ]($style)";
      };

      java = {
        style = "fg:#3b4252 bg:#8fbcbb";
        format = "[$symbol$version ]($style)";
      };

      nodejs = {
        symbol = "";
        style = "fg:#3b4252 bg:#8fbcbb";
        format = "[$symbol($version) ]($style)";
      };

      rust = {
        style = "fg:#3b4252 bg:#8fbcbb";
        format = "[$symbol($version) ]($style)";
      };

      ruby = {
        style = "fg:#3b4252 bg:#8fbcbb";
        format = "[$symbol($version) ]($style)";
      };

      character = {
        success_symbol = "";
        error_symbol = "[◉](bold fg:#bf616a bg:#8fbcbb)";
        format = "$symbol";
      };
    };
  };

  home.file.".vimrc".source = ./vimrc;
  home.sessionVariables.EDITOR = "vim";

  programs.fzf = {
    enable = true;
  };

  # Configure programs; https://rycee.gitlab.io/home-manager/options.html to see options
  programs.git = {
    enable = true;
    userEmail = "d@vidhughes.com";
    userName = "David Hughes";
    signing.key = "D9DAFC63";
    extraConfig = {
      commit = {
        gpgSign = true;
      };
      tag = {
        gpgSign = true;
      };
      init = {
        defaultBranch = "main";
      };
      rebase = {
        autosquash = true;
      };
    };
  };

  # Language environment zsh hooks
  home.file.".irbrc".source = ./irbrc;

  home.file.".ipython/profile_default/startup/autoreload.ipy".text = ''
    %load_ext autoreload
    %autoreload 2
  '';

  home.file.".clojure/deps.edn".source = ./clojure-deps.edn;
  home.file.".lein/profiles.clj".source = ./lein-profiles.clj;

  home.file.".config/zsh/scripts/rust.zsh".text = ''
    # Load PATH and any other environment updates from rustup/cargo
    test -f ''${HOME}/.cargo/env && source ''${HOME}/.cargo/env
  '';

  home.file.".config/zsh/scripts/golang.zsh".text = ''
    [[ -s "''${HOME}/.gvm/scripts/gvm" ]] && source "''${HOME}/.gvm/scripts/gvm

    gvm use go1.19 >> /dev/null
    gvm pkgset use global >> /dev/null
  '';

  # Desktop automation
  home.file.".config/karabiner" = { source = ./karabiner; recursive = true; };

  home.file.".config/skhd/skhdrc".text = ''
    # NOTE: for this to work, the `dave` CLI tool needs to be on skhd's PATH. This can be configured in the .plist file
    # that configures how the skhd service operates, which should be in `~/Library/LaunchAgents/com.koekeishiya.skhd.plist`
    # (when installed via `skhd --install-service`)
    fn + cmd - h : dave odc-move-space left
    fn + cmd - j : dave odc-move-space down
    fn + cmd - k : dave odc-move-space up
    fn + cmd - l : dave odc-move-space right

    fn + alt + cmd - h : dave odc-move-window left --follow
    fn + alt + cmd - j : dave odc-move-window down --follow
    fn + alt + cmd - k : dave odc-move-window up --follow
    fn + alt + cmd - l : dave odc-move-window right --follow

    # ctrl + alt - j : dave odc-invert-space vertical
    # ctrl + alt - k : dave odc-invert-space vertical
    # ctrl + alt - h : dave odc-invert-space horizontal
    # ctrl + alt - l : dave odc-invert-space horizontal

    ctrl + alt - s : dave odc-set-space-layout stack
    ctrl + alt - b : dave odc-set-space-layout bsp
    ctrl + alt - f : dave odc-set-space-layout float

    # USB keyboard with [Ctrl][Cmd][Alt]
    ctrl + alt - h : dave odc-move-space left
    ctrl + alt - j : dave odc-move-space down
    ctrl + alt - k : dave odc-move-space up
    ctrl + alt - l : dave odc-move-space right

    ctrl + alt + cmd - h : dave odc-move-window left --follow
    ctrl + alt + cmd - j : dave odc-move-window down --follow
    ctrl + alt + cmd - k : dave odc-move-window up --follow
    ctrl + alt + cmd - l : dave odc-move-window right --follow

    alt - tab : skhd -k "cmd - tab"

    # Firefox unfuck
    ctrl - t : skhd -k "cmd - t"
    ctrl - w : skhd -k "cmd - w"
    # ctrl - l : skhd -k "cmd - l"

    # Experimental
    f7: dave odc-log 'f7'
  '';

  # GPG signing
  home.file.".gnupg/gpg.conf".text = ''
    use-agent
  '';

  home.file.".gnupg/gpg-agent.conf".text = ''
    default-cache-ttl 86400
    max-cache-ttl 86400
  '';

  home.file.".config/zsh/scripts/gpg.zsh".text = ''
    export GPG_TTY=''$(tty)
    gpgconf --launch gpg-agent
  '';

  nixpkgs.config = {
    allowUnfree = true;

  };
}
