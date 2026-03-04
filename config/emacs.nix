{pkgs, ...}:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      vterm
      pdf-tools
      pkgs.mu
      mu4e
      treesit-grammars.with-all-grammars
    ];
  };
  services.emacs.enable = true;
  home.sessionVariables.EDITOR = "${pkgs.emacs}/bin/emacsclient";
}
