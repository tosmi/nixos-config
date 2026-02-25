{pkgs, ...}:
{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      sync_address = "https://atuin.lan.stderr.at";
    };
  };
}
