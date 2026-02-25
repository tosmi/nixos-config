{pkgs, ...}:
{
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



}
