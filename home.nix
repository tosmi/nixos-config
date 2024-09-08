{ config, pkgs, ... }:
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
          (dicts: with dicts; [ de en en-computers en-science ]))

    # required to install vms with lab_utilities
    pkgs.virt-manager
    pkgs.guestfs-tools
    pkgs.libguestfs

    # render markdown
    pkgs.pandoc

    # other packages
    pkgs.passwdqc
    pkgs.jetbrains-mono
    pkgs.pass
    pkgs.git
    pkgs.otpclient
    pkgs.jq
    pkgs.starship
    pkgs.slack
    pkgs.skopeo
    pkgs.podman
    pkgs.kubectl
    pkgs.openshift
    pkgs.crc
    pkgs.mu
    pkgs.isync
    pkgs.jdk
    pkgs.go
    pkgs.tektoncd-cli
    pkgs.vlc
    pkgs.signal-desktop
    pkgs.stern
    pkgs.nodejs_22
    pkgs.zeal
    pkgs.seahorse

    #unstable.quarkus
    #unstable.k9s
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
  programs.browserpass.browsers = [ "firefox" ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # programs.bash =  {
  #   enable = true;
  # };


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
        ];
    };
  };

  programs.emacs = {
    package = pkgs.emacs29-pgtk;
    enable = true;
    extraPackages = epkgs: with epkgs; [
      vterm
      pdf-tools
      pkgs.mu
      mu4e
    ];
  };

  programs.kitty = {
    # on non-nixos system this requires kitty to be installed outside of nixpkgs
    enable = true;
    theme = "Modus Operandi Tinted";
    font.name = "JetBrains Mono";
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

}
