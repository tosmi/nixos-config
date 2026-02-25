{pkgs, ...}:
{
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
      background-opacity = 0.95;
      theme = "Argonaut";
      keybind = [

      ];
    };
  };
}
