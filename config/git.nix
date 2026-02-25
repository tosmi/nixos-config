{pkgs, ...}:
{
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

}
