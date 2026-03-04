{pkgs, ...}:
{
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
      "passwdqc"
      "opa"
    ];

    casks = [
      "ghostty"
      "firefox"
      "citrix-workspace"
      "slack"
      "jetbrains-toolbox"
      "cursor"
      "cursor-cli"
      "microsoft-teams"
      "stats"
      "rectangle"
      "vlc"
      "windows-app"
      "karabiner-elements"
      "balenaetcher"
      "tailscale-app"
      "synology-drive"
      "miro"
      "signal"
      "utm"
      "podman-desktop"
      "visual-studio-code"
      "drawio"
      "tunnelblick"
    ];
  };
}
