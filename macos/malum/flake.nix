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
          ({ pkgs, lib, ... }:
            let
              global = import ../../config/globals.nix;
            in
            {
              networking.hostName = "malum";

              nix.extraOptions = ''
           experimental-features = flakes nix-command
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
                };

                brews = [
                  "ollama"
                  "llama.cpp"
                ] ++ global.brews;

                casks = global.casks;

                taps = global.taps;
              };
            })

          inputs.home-manager.darwinModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.pinhead.imports = [
  	            ({pkgs, ...}:
                  {
                    imports = [
                      ../../config/tmux.nix
                      ../../config/bash.nix
                      ../../config/emacs.nix
                      ../../config/startship.nix
                      ../../config/git.nix
                      ../../config/atuin.nix
                      ../../config/ghostty.nix
                    ];
                    home.stateVersion = "25.11";
                    home.homeDirectory = "/Users/pinhead";

                    home.packages = [
                      pkgs.ripgrep
                      pkgs.curl
                      pkgs.less
                      pkgs.pass
                      pkgs.isync
                      # pkgs.jetbrains-mono
                      pkgs.go
                      pkgs.gnupg
                      pkgs.kubectl
                      pkgs.kubectl-neat
                      pkgs.blesh
                      pkgs.mu
                      pkgs.ansible
                      pkgs.ansible-lint
                      pkgs.ansible-navigator
                      pkgs.gnused
                      pkgs.git-filter-repo
                      pkgs.ffmpeg
                      pkgs.kubevirt
                      pkgs.uv
                      pkgs.devcontainer
                      pkgs.stern
                      pkgs.awscli2

                      # lsp's
                      pkgs.ruff  # python
                      pkgs.yaml-language-server
                      pkgs.gopls
                      pkgs.bash-language-server

                      pkgs.aspell
                      pkgs.aspellDicts.de
                      pkgs.aspellDicts.en
                      pkgs.aspellDicts.en-computers

                      # https://github.com/nixos/nixpkgs/issues/476684
                      # (pkgs.aspellWithDicts
                      #   (dicts: with dicts; [ de en en-computers ]))
                    ];

                    fonts.fontconfig.enable = true;

                    home.sessionVariables = {
                      PAGER = "less -X";
                      CLICOLOR = 1;
                      # required because of https://github.com/nixos/nixpkgs/issues/476684
                      # spell can find filters and modes but not the dicts when
                      # we do not use pkgs.aspellWithDicts
                      ASPELL_CONF = "dict-dir ${pkgs.aspellWithDicts (dicts: with dicts; [ en ])}/lib/aspell";
                    };

                    # programs.gpg.enable = true;

                    programs.bat.enable = false;
                    programs.bat.config.theme = "TwoDark";

                    programs.browserpass.enable = true;
                    programs.browserpass.browsers = [ "firefox" "chrome" "chromium" ];

                    programs.kubecolor.enable = true;
                  }
                )
              ];
            };
          }
        ];
      };
  };
}
