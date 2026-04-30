{
  pkgs,
  llm-agents,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      # mitmproxy # http/https proxy tool
      # wireshark # network analyzer

      antigravity

      android-studio
      android-tools
    ]
    # AI Agent Tools
    ++ (with llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      # Agents
      # codex
      # cursor-cli

      claude-code
      # claude-code-router

      gemini-cli
      # opencode

      # Utilities
      rtk # CLI proxy that reduces LLM token consumption
    ]);

  programs.zsh.initContent = ''
    if [ -f "/run/agenix/api-keys.env" ]; then
      source "/run/agenix/api-keys.env"
    fi
  '';
}
