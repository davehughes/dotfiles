{ config, pkgs, ... }:

let
  tmuxThemepack = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "themepack";
    version = "1.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "jimeh";
      repo = "tmux-themepack";
      rev = "1.1.0";
      # obtained by running `nix-prefetch-url --unpack https://github.com/<author>/<repo>/archive/<rev>.tar.gz`
      sha256 = "00dmd16ngyag3n46rbnl9vy82ih6g0y02yfwkid32a1c8vdbvb3z";
    };
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
  home.packages = [
    pkgs.direnv
    pkgs.vim
    pkgs.fasd
    pkgs.stow
    pkgs.ripgrep
    pkgs.jq
    pkgs.yq
    pkgs.jet
    pkgs.tree
    pkgs.ctags

    pkgs.skhd
    pkgs.yabai
    pkgs.karabiner-elements
    pkgs.reattach-to-user-namespace

    pkgs.babashka
    pkgs.pwgen
    pkgs.oath-toolkit
    pkgs.rlwrap
    pkgs.libpqxx

    pkgs.racket

    # brew install ruby
    # brew install ruby-build
    # brew install redis
    # brew install golang
    # # Install libpq (postgres) libs and binaries like psql
    # brew install libpq
    # brew link --force libpq
    # brew install --cask snowflake-snowsql

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    # NOTE: there's a bootstrapping problem here...
    # ".config/nix/nix.conf".source = nix/nix.conf;

    ".config/zsh" = { source = ./zsh; recursive = true; };

    ".skhdrc".source = ./skhdrc;

    # TODO: replace this with home-manager's programs.gpg?
    ".gnupg/gpg.conf".text = ''
      use-agent
    '';

    ".gnupg/gpg-agent.conf".text = ''
      default-cache-ttl 86400
      max-cache-ttl 86400
    '';

    ".config/zsh/scripts/gpg.zsh".text = ''
      export GPG_TTY=''$(tty)
      gpgconfg --launch gpg-agent
    '';

    ".ipython/profile_default/startup/autoreload.ipy".text = ''
      %load_ext autoreload
      %autoreload 2
    '';

    ".config/karabiner" = { source = ./karabiner; recursive = true; };
  };

  home.file.".vimrc".source = ./vimrc;
  home.sessionVariables.EDITOR = "vim";

  home.sessionVariables = {
    PAGER = "less";
    TERM = "tmux-256color";

    # Don't rename the terminal, it's likely a tmux window that I already named
    DISABLE_AUTO_TITLE = "true";
    VIRTUAL_ENV_DISABLE_PROMPT = "true";
  };

  home.sessionPath = [
    # Add homebrew bin directory
    # /opt/homebrew/bin

    # python-tools bin directory
    "$HOME/.local/python-tools/bin"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables.TMUX_THEME = "powerline/double/purple";
  programs.tmux = {
    enable = true;
    tmuxp.enable = true;
    escapeTime = 0;
    historyLimit = 50000;
    disableConfirmationPrompt = true;
    plugins = with pkgs; [
      # tmuxPlugins.yank
      tmuxThemepack
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

      # reload tmux config
      bind R source ~/.config/tmux/tmux.conf

      set-window-option -g automatic-rename off
      set -s set-clipboard on
      set -g default-terminal tmux-256color
      set -ga terminal-overrides ",*256col*:Tc"

      # get rid of annoying lag when pressing Esc in vims
      set -s escape-time 0
    '';
  };

  home.file.".tmuxp" = { source = ./tmuxp; recursive = true; };

  programs.zsh = {
    enable = true;

    zplug = {
      enable = true;
      # TODO: peruse https://github.com/unixorn/awesome-zsh-plugins and add anything that looks useful
      plugins = [
        { name = "plugins/fasd"; tags = ["from:oh-my-zsh"]; }
        { name = "plugins/gitfast"; tags = ["from:oh-my-zsh"]; }
        { name = "plugins/gpg-agent"; tags = ["from:oh-my-zsh"]; }
        { name = "plugins/ssh-agent"; tags = ["from:oh-my-zsh"]; }
        { name = "plugins/pip"; tags = ["from:oh-my-zsh"]; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = ["defer:2"]; }
        { name = ".config/zsh/themes/davehughes"; tags = ["from:local" "as:theme"]; }
      ];
    };

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

      mfa = "~/bin/mfa.py --config=$HOME/.mfa";
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
    '';

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
    ];
  };

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

  home.file.".clojure/deps.edn".source = ./clojure-deps.edn;
  home.file.".lein/profiles.clj".source = ./lein-profiles.clj;

  home.file.".config/zsh/scripts/rust.zsh".text = ''
    # Load PATH and any other environment updates from rustup/cargo
    test -f ''${HOME}/.cargo/env && source ''${HOME}/.cargo/env
  '';

  home.file.".config/zsh/scripts/gvm.zsh".text = ''
    [[ -s "''${HOME}/.gvm/scripts/gvm" ]] && source "''${HOME}/.gvm/scripts/gvm
  '';
}
