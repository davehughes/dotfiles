{ config, pkgs, ... }:

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
    pkgs.yabai
    pkgs.fasd
    pkgs.stow
    pkgs.tmux
    pkgs.tmuxp
    pkgs.pwgen
    pkgs.jq
    pkgs.yq

    # brew install ruby
    # brew install ruby-build
    # brew install ./brew/vim.rb --env=std --with-features=big
    # brew install zsh
    # brew install ctags-exuberant
    # brew install git-secret
    # brew install rlwrap
    # brew install outh-toolkit
    # brew install pwgen
    # brew install Caskroom/cask/karabiner-elements
    # brew install Caskroom/cask/seil
    # brew install reattach-to-user-namespace --with-wrap-pbcopy-and-pbpaste
    # brew install jq
    # brew install tree
    # brew install ripgrep
    # brew install borkdude/brew/babashka
    # brew install borkdude/brew/jet
    # brew install koekeishiya/formulae/yabai
    # brew install koekeishiya/formulae/skhd
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dave/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "vim";
    PAGER = "less";
    TERM = "xterm-256color";

    # Don't rename the terminal, it's likely a tmux window that I already named
    DISABLE_AUTO_TITLE = "true";
    VIRTUAL_ENV_DISABLE_PROMPT = "true";
    TMUX_THEME_COLOR = "purple";
    TMUX_THEME = "powerline/double/${TMUX_THEME_COLOR}";
  };

  home.sessionPath = {
    # Add homebrew bin directory
    # add_to_PATH /opt/homebrew/bin

    # Add personal bin directory
    "$HOME/bin"
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "davehughes";
      custom = "$HOME/.dotfiles/oh-my-zsh-custom";
      plugins = [
        "fasd"
        "gitfast"
        "gpg-agent"
        "pip"
        "ssh-agent"
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

  programs.vim = {
    enable = true;
    defaultEditor = true;
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
}
