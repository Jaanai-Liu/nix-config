{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # vscode
    # antigravity
    claude-code
    litellm

    android-studio
    android-tools
  ];

  systemd.user.services.litellm = {
    Unit = {
      Description = "LiteLLM Proxy for Claude Code (Gemini Backend)";
      After = [ "network.target" ];
    };
    Service = {
      EnvironmentFile = "/etc/agenix/api-keys.env";
      ExecStart = "${pkgs.litellm}/bin/litellm --model gemini/gemini-1.5-pro-latest --port 4000";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  programs.zsh.initExtra = ''
    if [ -f /etc/agenix/api-keys.env ]; then
      source /etc/agenix/api-keys.env
    fi
  '';
}
