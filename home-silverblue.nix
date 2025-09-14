{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  standardPackages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

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

    (pkgs.aspellWithDicts
      (dicts: with dicts; [ de en en-computers en-science es fr la ]))

    # devconf
    pkgs.kind

    # required to install vms with lab_utilities
    pkgs.virt-manager
    pkgs.guestfs-tools
    pkgs.libguestfs

    # render markdown
    pkgs.pandoc

    # other packages
    pkgs.blesh
    pkgs.bfg-repo-cleaner
    pkgs.ripgrep

    pkgs.kepubify
    pkgs.passwdqc
    pkgs.jetbrains-mono
    pkgs.pass
    pkgs.git
    pkgs.otpclient
    pkgs.jq

    # flatpack
    # pkgs.slack

    pkgs.skopeo
    pkgs.podman
    pkgs.mu
    pkgs.isync
    pkgs.vlc
    pkgs.signal-desktop
    pkgs.nodejs_22
    pkgs.zeal
    pkgs.seahorse

    # install globally because i use it all the time
    pkgs.istioctl
    pkgs.kubectl
    pkgs.kubectl-neat
    pkgs.kustomize
    pkgs.kubernetes-helm
    pkgs.k9s
    pkgs.stern
    pkgs.operator-sdk

    pkgs.openshift
    pkgs.tektoncd-cli

    pkgs.ansible
    pkgs.ansible-lint

    pkgs.jdk
    pkgs.quarkus
    pkgs.babashka

    pkgs.godef
    pkgs.go

    pkgs.postgresql
  ];

  nixosPackages = [
    pkgs.pinentry-gnome3
    pkgs.gnome.gnome-tweaks
    pkgs.gnome.gnome-boxes
    pkgs.gnomeExtensions.just-perfection
  ];

  silverbluePackages = [];

in
{
  nixGL.packages = import <nixgl> { inherit pkgs; };
  nixGL.defaultWrapper = "mesa";

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "pinhead";
  home.homeDirectory = "/home/pinhead";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages =  if builtins.pathExists /sysroot/ostree
                   then
                     standardPackages ++ silverbluePackages
                   else
                     standardPackages ++ nixosPackages;

  fonts.fontconfig.enable = true;

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/pinhead/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.browserpass.enable = true;
  programs.browserpass.browsers = [ "firefox" "chrome" "chromium" ];

  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  # };

  programs.kubecolor.enable = true;

  programs.bash =  {
    enable = true;
    enableCompletion = true;

    bashrcExtra = "source -- \"$(blesh-share)\"/ble.sh --attach=none";
    initExtra = ''
    # if [[ "$INSIDE_EMACS" = 'vterm' ]] \
    #     && [[ -n "$EMACS_VTERM_PATH" ]] \
    #     && [[ -f "$EMACS_VTERM_PATH/etc/emacs-vterm-bash.sh" ]]; then
    # 	source "$EMACS_VTERM_PATH/etc/emacs-vterm-bash.sh"

    #   # command -v starship # && starship_precmd_user_func="vterm_prompt_end"
    # fi

    function vterm_printf(){
      if [ -n "$TMUX" ] && ([ "''${TERM%%-*}" = "tmux" ] || [ "''${TERM%%-*}" = "screen" ] ); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
      elif [ "''${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
    	  printf "\eP\e]%s\007\e\\" "$1"
      else
        printf "\e]%s\e\\" "$1"
      fi
    }

    vterm_prompt_end() {
      vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
    }

    PATH=$PATH:~/bin:~/.local/bin

    [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';

    shellAliases = {
      j="jobs -l";

      z="suspend";
      x="exit";
      pd="pushd";
      pd2="pushd +2";
      pd3="pushd +3";
      pd4="pushd +4";

      ls="ls --hyperlink=auto -NF --color";
      ll="ls --hyperlink=auto -l";
      li="ls --hyperlink=auto -li";
      la="ls --hyperlink=auto -la";
      lt="ls --hyperlink=auto -tral";

      dirs="dirs -v";

      egrep="egrep --color=tty -d skip";
      fgrep="fgrep --color=tty -d skip";
      grep="grep --color=tty -d skip";
      t="TERM=xterm-256color tmux";
      ta="TERM=xterm-256color tmux attach -t";
      e="emacs -nw";

      gpu="git pull";
      gps="git push";

      psh="ps -fu pinssh";
      kpsh="sudo pkill -u pinssh";

      E="SUDO_EDITOR=\"emacsclient -c -a emacs\" sudoedit";

      psu="ps -fu pinhead";
      psukill="sudo -u pinhead /usr/bin/pkill -U pinhead sshd";

      k="kubectl";

      m="emacsclient -n -e \\(magit-status\\)";
      p="podman";
      h="flatpak-spawn --host";
      hvirsh="flatpak-spawn --host virsh -c qemu:///system";

      ocphome="oc login -u root https://api.ocp.lan.stderr.at:6443";
      ocphetzner="oc login -u root https://api.hetzner.tntinfra.net:6443";
      ocpaws="oc login -u root https://api.hub.aws.tntinfra.net:6443";

      uvirsh="virsh -c qemu:///session";
      svirsh="virsh -c qemu:///system";

      gnome-backup="dconf dump / > $${HOME}/etc/gnome_settings-$(hostname).backup";
      gnome-restore="dconf load -f / < $${HOME}/etc/gnome_settings-$(hostname).backup";

      oc="env KUBECTL_COMMAND=oc kubecolor";
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        show-battery-percentage = true;
      };

      "org/gnome/desktop/wm/keybindings" = {
        close = ["<Shift><Super>q"];
        move-to-monitor-left =["<Shift><Super>Up"];
        move-to-monitor-right =["<Shift><Super>Down"];
        toggle-fullscreen= ["<Shift><Super>f"];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding="<Shift><Super>s";
        command="systemctl suspend";
        name="Suspend";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding="<Shift><Super>o";
        command="systemctl poweroff";
        name="Suspend";
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        ];

        screensaver = ["<Shift><Super>l" ];
      };

      "org/gnome/shell".enabled-extensions = [
        "just-perfection-desktop@just-perfection"
        "freon@UshakovVasilii_Github.yahoo.com"
        "caffeine@patapon.info"
        "tailscale-status@maxgallup.github.com" "switcher@landau.fi"
        "GPaste@gnome-shell-extensions.gnome.org"
        "quake-terminal@diegodario88.github.io"
        "paperwm@paperwm.github.com" ]; }; };

  programs.emacs = {
    package = pkgs.emacs30-pgtk;
    enable = true;
    extraPackages = epkgs: with epkgs; [
      vterm
      pdf-tools
      pkgs.mu
      mu4e
    ];
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
    startWithUserSession = "graphical";
  };

  services.podman = {
    enable = true;
  };

  services.home-manager.autoExpire = {
    enable = true;
    store.cleanup = true;
    store.options = "--delete-older-than 30d";
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$kubernetes"
        "$conda"
        "$line_break"
        "$os"
        "$container"
        "$directory"
        "$git_branch"
        "$git_status"
        "$character"
      ];

      username.disabled = false;

      kubernetes = {
        disabled = false;
        format = "[⛵ $user on $context \\[$namespace\\]](dimmed green) ";
      };

      kubernetes.contexts = [
        {
          user_pattern = "system:admin/.*";
          user_alias   = "admin";
        }
        {
          user_pattern = "kube:admin/.*";
          user_alias   = "kube:admin";
        }
        {
          user_pattern = "root/.*";
          user_alias   = "root";
        }
        {
          context_pattern = "dev.local.cluster.k8s";
          context_alias   = "dev";
        }
        {
          context_pattern = ".*hub.*aws-tntinfra.*";
          context_alias   = "aws-hub";
          user_pattern = "root/.*";
          user_alias   = "root";
        }
        {
          context_pattern = ".*ocp.*aws-tntinfra.*";
          context_alias   = "aws-ocp";
        }
        {
          context_pattern = ".*/openshift-cluster/.*";
          context_alias   = "openshift";
        }
        {
          context_pattern = "gke_.*_(?P<var_cluster>[\w-]+)";
          context_alias   = "gke-$var_cluster";
        }
      ];

      character = {
        success_symbol = "[➜](bold green) ";
        error_symbol = "[✗](bold red) ";
      };

      aws.disabled = true;
    };
  };

  programs.git = {
    enable = true;

    userEmail = "toni@stderr.at";
    userName = "Toni Schmidbauer";

    signing = {
      signByDefault = true;
      key = "8C6444B3";
    };

    extraConfig = {
      commit = {
        gpgSign = true;
      };

      apply = {
        whitespace = "warn";
      };

      diff = {
        rename = "copy";
        renamelimit = "600";
      };

      pager = {
        color = true;
      };

      color = {
        branch = "auto";
        diff = "auto";
        interactive = "auto";
        status = "auto";
      };

      push = {
	      default = "current";
      };

      pull = {
	      rebase = false;
      };

      init = {
	      defaultBranch = "main";
      };

      github = {
	      user = "tosmi";
      };
    };

    aliases = {
      ci = "commit -a";
      st = "status";
      plog = "log --pretty --color --dirstat --summary --stat";
      diffstat = "diff --stat";
      ds = "diff --stat";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      pu = "pull";
      pur = "pull --rebase";
      cam = "commit -am";
      ca = "commit -a";
      cm = "commit -m";
      co = "checkout";
      br = "branch -v";
      unstage = "reset HEAD --";
      find = "!sh -c 'git ls-tree -r --name-only HEAD | grep --color $1' -";
      cleanup = "!git branch --merged master | grep -v 'master$' | xargs git branch -d";
      g = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      h = "!git --no-pager log origin/master..HEAD --abbrev-commit --pretty=oneline";
      root = "rev-parse --show-toplevel";
    };
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };

  programs.tmux = {
	  enable = true;

	  clock24 = true;
	  plugins = with pkgs.tmuxPlugins; [
		  sensible
		  yank
		  {
			  plugin = dracula;
			  extraConfig = ''
        				set -g @dracula-show-battery false
         				set -g @dracula-show-powerline true
         				set -g @dracula-refresh-rate 10
                '';
		  }
	  ];

	  extraConfig = ''
    		set -g mouse on
       '';
  };

  home.activation = {
    linkDesktopApplications = {
      after = [ "writeBoundary" "createXdgUserDirectories" ];
      before = [ ];
      data = ''
        rm -rf ${config.xdg.dataHome}/"applications/home-manager"
        mkdir -p ${config.xdg.dataHome}/"applications/home-manager"
        cp -Lr ${config.home.homeDirectory}/.nix-profile/share/applications/* ${config.xdg.dataHome}/"applications/home-manager/"
      '';
    };
  };

  # home.file  = {
  #   "test" = {
  #     text = ''
  #     test
  #     '';
  #   };

  #   ".private".source = fetchGit {
  #     url = "ssh://git@gitlab.lan.stderr.at:2222/tosmi/private.git";
  #     ref = "master";
  #     # rev = "1d79552e3976d798561f9c8d6fcbcd2f66dc08a4";
  #   };

  #   ".ssh".source = config.lib.file.mkOutOfStoreSymlink ~/.private/.ssh;
  # };

}
