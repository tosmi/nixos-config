{
 description = "my minimal flake";

 inputs = {
   nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

   home-manager.url = "github:nix-community/home-manager/master";
   home-manager.inputs.nixpkgs.follows = "nixpkgs";

   darwin.url = "github:nix-darwin/nix-darwin";
   darwin.inputs.nixpkgs.follows = "nixpkgs";
 };

 outputs = inputs: {
   darwinConfigurations.malum =
     inputs.darwin.lib.darwinSystem {
       system = "aarch64-darwin";
       pkgs = import inputs.nixpkgs {
         system = "aarch64-darwin";
       };
       modules = [
         # because this is a list of modules and we want to call a function {}
         # we have to put the function inside () which makes this a single list item.
         # space separates list items in nix
         ({ pkgs, ... }: {

           networking.hostName = "malum";

           nix.extraOptions = ''
           experimental-features = flakes
           '';

           services.openssh.enable = true;

           # darwin preferences
           programs.bash.enable = true;
           programs.bash.completion.enable = true;

           environment.shells = [ pkgs.bash pkgs.zsh ];

           users.users.pinhead.home = "/Users/pinhead";

           programs.direnv.enable = true;

           #nix.extraOptions = ''
           #  experimantal-features = nix-command flakes
           #'';

           environment.systemPackages = [ pkgs.coreutils ];

           system.keyboard.enableKeyMapping = true;
           system.keyboard.remapCapsLockToEscape = true;

           # fonts.packages = [ (pkgs.nerdfonts.override { fonts = ["Meslo"]; }) ];

           system.defaults = {
             finder.AppleShowAllExtensions = true;
             finder._FXShowPosixPathInTitle = true;

             NSGlobalDomain.AppleShowAllExtensions = true;
             NSGlobalDomain.InitialKeyRepeat = 14;
             NSGlobalDomain.KeyRepeat = 1;

             dock.autohide = true;

             CustomSystemPreferences = {
               "org.gpgtools.common" = {
                 UseKeychain = false;
                 DisableKeychain = true;
               };
             };
           };

           system.stateVersion = 6;
           system.primaryUser = "pinhead";

           security.pki.certificates = [
           ''
             -----BEGIN CERTIFICATE-----
             MIIDSzCCAjOgAwIBAgIUCf/oYHjLxpVvmy9s9Eo55vE6e9swDQYJKoZIhvcNAQEL
             BQAwFjEUMBIGA1UEAwwLdG50aW5mcmEgQ0EwHhcNMjEwNzEzMTEzODM4WhcNMzEw
             NzExMTEzODM4WjAWMRQwEgYDVQQDDAt0bnRpbmZyYSBDQTCCASIwDQYJKoZIhvcN
             AQEBBQADggEPADCCAQoCggEBAJzEkp5JqJmhE86G+OilwTSDxJn2svGtY3USapmC
             PfVpMf1kj0o0vUhULqUcbp4AQ3J/NzfsPuwfX39zNF/Tp+cSD2lS63sEyXRb20dh
             9DVOmBH4R0uePir83OfJhvoD7kBIYYESHyC0B/V7TJ/V7fDwkQFDHZFnAZytpMCq
             H4ctZwemIftKeTOvytcTeZHaIMHu1Ze+N6wn4alyY6TyGcz+i65BtaMeqoVx503p
             HrBPMbWLSFQW6f3BN9joY0K3VDBSYCyFw4Wkqph/AcQiQylvv6u3hQdiu3An4PzZ
             36ac92HeAbaOh7CT5c1z8eY93CFFnAajhLeV+bsVySrgLusCAwEAAaOBkDCBjTAd
             BgNVHQ4EFgQUMsXWXteGVZ0z3k5vslGek74xaUswUQYDVR0jBEowSIAUMsXWXteG
             VZ0z3k5vslGek74xaUuhGqQYMBYxFDASBgNVBAMMC3RudGluZnJhIENBghQJ/+hg
             eMvGlW+bL2z0Sjnm8Tp72zAMBgNVHRMEBTADAQH/MAsGA1UdDwQEAwIBBjANBgkq
             hkiG9w0BAQsFAAOCAQEAczy5XZVQ1OqVznOHSIzucsfa7+/0TUw94ebzxGUMZJis
             j7yGvdD1aDf/DrL2UCPiP2av3EGeK1eMdQ/U845O9HcA6t24wI5vcbK35rddSdVO
             o/fDu5WyA5naEjPPzdzFt/wVWxfFslCHQGAhOOz9RF8631CyEfjYetNA9b1dDOEy
             0r/nmIaJ7GmeDoQ6W0cnYxUUi6zsxpAedqnYTfpB5gntB4hXiblhGiOMkw3E4NHy
             Lv+Z+rzQgoylI2IFe/EswzgUJlOKZAL+gnslVRZAVsl/VfWI5YFzMgNANAIqNp8p
             t1/G6SW5/B+nUwSVBa/mjHelA0R7HZ73nkdwbxAAOg==
             -----END CERTIFICATE-----
           ''
           ];

           homebrew = {
             enable = true;
             onActivation = {
               autoUpdate = true;
               cleanup = "zap";
               upgrade = true;
             };

             global = {
               brewfile = true;
               lockfiles = false;
             };

             #taps = [
             #  "homebrew/cask"
             #];

             brews = [
               "trash"
               "gemini-cli"
             ];

             casks = [
               "ghostty"
               "firefox"
               "citrix-workspace"
               "slack"
               "intellij-idea"
               "pycharm"
               "goland"
               "cursor"
               "microsoft-teams"
               "stats"
               "rectangle"
               "hyperkey"
               "charmstone"
               "vlc"
               "windows-app"
               "karabiner-elements"
             ];
           };
         })

         inputs.home-manager.darwinModules.home-manager {
           home-manager = {
             useGlobalPkgs = true;
             useUserPackages = true;
             users.pinhead.imports = [
  	     ({pkgs, ...}:
                 {
                   home.stateVersion = "25.11";
                   home.homeDirectory = "/Users/pinhead";

                   home.packages = [
                     pkgs.ripgrep
                     pkgs.curl
                     pkgs.less
                     pkgs.pass
                     pkgs.isync
                     pkgs.jetbrains-mono
                     pkgs.go
                     pkgs.gnupg
                     pkgs.kubectl
                     pkgs.blesh
                     pkgs.mu
                     pkgs.ansible
                     pkgs.ansible-navigator
                     pkgs.passwdqc

                     (pkgs.aspellWithDicts
                       (dicts: with dicts; [ de en en-computers ]))
                   ];

                   # (dicts: with dicts; [ de en en-computers en-science es fr la ]))

                   fonts.fontconfig.enable = true;

                   home.sessionVariables = {
                     PAGER = "less -X";
                     CLICOLOR = 1;
                   };

                   # programs.gpg.enable = true;

                   programs.bat.enable = false;
                   programs.bat.config.theme = "TwoDark";

                   programs.bash =  {
                     enable = true;
                     enableCompletion = true;

                     bashrcExtra = ''
                       export PATH=$HOME/.local/bin:/opt/homebrew/bin:/opt/podman/bin:$PATH
                       source -- "$(blesh-share)"/ble.sh --attach=none
                     '';

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

                       export KUBECOLOR_PRESET="light"
                       PATH=$HOME/bin:$HOME/.local/bin:$PATH

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

                       ocphome="oc login -u root https://api.sno.lan.stderr.at:6443";
                       ocphetzner="oc login -u root https://api.hetzner.tntinfra.net:6443";
                       ocpaws="oc login -u root https://api.hub.aws.tntinfra.net:6443";

                       uvirsh="virsh -c qemu:///session";
                       svirsh="virsh -c qemu:///system";

                       gnome-backup="dconf dump / > $${HOME}/etc/gnome_settings-$(hostname).backup";
                       gnome-restore="dconf load -f / < $${HOME}/etc/gnome_settings-$(hostname).backup";

                       oc="env KUBECTL_COMMAND=oc kubecolor";
                     };
                   };

                   programs.emacs = {
                     enable = true;
                     extraPackages = epkgs: with epkgs; [
                       vterm
                       pdf-tools
                       pkgs.mu
                       mu4e
                     ];
                   };

                   programs.browserpass.enable = true;
                   programs.browserpass.browsers = [ "firefox" "chrome" "chromium" ];

                   programs.kubecolor.enable = true;

                   programs.starship = {
                     enable = true;
                     enableBashIntegration = true;
                     settings = {
                       format = pkgs.lib.concatStrings [
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

                     signing = {
                       signByDefault = true;
                       key = "8C6444B3";
                     };

                     settings = {
                       user = {
                         name ="Toni Schmidbauer";
                         email = "toni@stderr.at";
                       };

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

                       alias = {
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


                   programs.ghostty = {
                     enable = true;
                     package = pkgs.emptyDirectory;
                     enableBashIntegration = true;
                     settings = {
                       shell-integration = "bash";
                       command = "/etc/profiles/per-user/pinhead/bin/bash";
                       shell-integration-features = "ssh-terminfo";
                       # font-family = "MesloLGS Nerd Font Mono";
                       font-family = "JetBrains Mono";
                       font-size = 18;
                       background-opacity = 0.9;
                       theme = "Argonaut";
                       keybind = [

                       ];
                     };
                   };
                 }
               )
             ];
           };
         }
       ];
     };
  };
}
