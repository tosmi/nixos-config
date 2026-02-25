{pkgs, ...}:
{
  programs.bash =  {
    enable = true;
    enableCompletion = true;

    historyControl = [ "ignoreboth" ];

    bashrcExtra = ''
      export PATH=$HOME/bin:$HOME/.local/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin

      if [ "$(uname -s)" == "Darwin" ]; then
         export PATH=$PATH:/opt/homebrew/bin:/opt/podman/bin:/bin:/usr/bin:/sbin:/usr/sbin
      fi
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
}
