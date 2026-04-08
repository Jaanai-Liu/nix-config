{
  pkgs,
  config,
  lib,
  myvars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.ai;
in
{
  options.modules.desktop = {
    ai = {
      enable = mkEnableOption "Local AI stack (Ollama + Open WebUI)";
    };
  };

  config = mkIf cfg.enable {
    # ==========================================================================
    # Local AI Stack
    #
    #   Ollama as the backend engine.
    #   Open WebUI serving at localhost:8080.
    # ==========================================================================

    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
    };

    services.open-webui = {
      enable = true;
      host = "0.0.0.0";
      port = 8080;
    };

    systemd.services.ollama.wantedBy = mkForce [ ];
    systemd.services.open-webui.wantedBy = mkForce [ ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };

    users.users.${myvars.username}.extraGroups = [
      "video"
      "render"
    ];

    networking.firewall.allowedTCPPorts = [ 8080 ];

    environment.shellAliases = {
      ai-up = "sudo systemctl start ollama open-webui && echo '🚀 AI 引擎已启动，请访问 localhost:8080'";
      ai-down = "sudo systemctl stop ollama open-webui && echo '💤 AI 引擎已关闭，显存已释放'";
      ai-st = "systemctl status ollama open-webui";
    };
  };
}
