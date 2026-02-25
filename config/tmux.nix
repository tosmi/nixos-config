{pkgs, ...}:
{
  programs.tmux = {
	  enable = true;
    keyMode = "emacs";
    mouse = true;
    prefix = "C-z";
    shortcut = "z";
    shell = "${pkgs.bash}/bin/bash";
	  clock24 = true;

    extraConfig = ''
      set-option -gu default-command
      set-option -g default-shell ${pkgs.bash}/bin/bash
      set-option -g extended-keys on
    '';

	  plugins = with pkgs.tmuxPlugins; [
		  sensible
		  yank
		  {
			  plugin = dracula;

        extraConfig = ''
          set -g @dracula-show-battery false
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 10
          set -g @dracula-show-fahrenheit false
          set -g @dracula-fixed-location "Vienna"
          set -g @dracula-git-colors "cyan dark_gray"
          set -g @dracula-uptime-colors "orange dark_gray"
          set -g @dracula-cpu-arch-colors "pink dark_gray"
          set -g @dracula-plugins "git cpu-arch uptime ssh-session"
        '';
		  }
	  ];
  };
}
