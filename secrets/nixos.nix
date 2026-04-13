{
  lib,
  config,
  pkgs,
  agenix,
  mysecrets,
  myvars,
  ...
}:
with lib;
let
  cfg = config.modules.secrets;

  noaccess = {
    mode = "0000";
    owner = "root";
  };
  high_security = {
    mode = "0500";
    owner = "root";
  };
  user_readable = {
    mode = "0500";
    owner = myvars.username;
  };
in
{
  imports = [
    agenix.nixosModules.default
  ];

  options.modules.secrets = {
    desktop.enable = mkEnableOption "NixOS Secrets for Desktops";
    mail.enable = mkEnableOption "NixOS Secrets for Mail Clients";
    server.proxy.enable = mkEnableOption "NixOS Secrets for Proxy Server";
  };

  config = mkMerge [

    # ==========================================
    # 🖥️ 【台式机专区】只有开启 desktop.enable 才加载
    # ==========================================
    (mkIf cfg.desktop.enable {
      environment.systemPackages = [
        agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
      ];

      age.identityPaths = [ "/persistent/etc/ssh/ssh_host_ed25519_key" ];

      age.secrets = {
        "ssh-key.age" = {
          file = "${mysecrets}/secrets/ssh-key-${config.networking.hostName}.age";
          # path = "/home/${myvars.username}/.ssh/id_ed25519";
          # owner = myvars.username;
          # mode = "0400";
        }
        // user_readable;

        "github-token" = {
          file = "${mysecrets}/secrets/github-token.age";
        }
        // high_security;

        "rclone-openlist" = {
          file = "${mysecrets}/secrets/rclone-openlist.age";
          # path = "/home/${myvars.username}/.config/rclone/rclone.conf";
          owner = myvars.username;
          group = "users";
          mode = "0500";
        };
      };

      nix.extraOptions = ''
        !include ${config.age.secrets."github-token".path}
      '';

      # environment.etc = {
      #   "agenix/id_ed25519" = {
      #     source = config.age.secrets."ssh-key.age".path;
      #     mode = "0500";
      #     user = myvars.username;
      #   };
      # };
    })

    # ==========================================
    # 📧 Mail config
    # ==========================================
    (mkIf cfg.mail.enable {
      age.secrets = {
        "aerc-accounts" = {
          file = "${mysecrets}/secrets/aerc-accounts.age";
          path = "/home/${myvars.username}/.config/aerc/accounts.conf";
        }
        // user_readable;
      };
    })

    # ==========================================
    # ☁️ VPS proxy
    # ==========================================
    (mkIf cfg.server.proxy.enable {
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      age.secrets = {
        "sing-box-uuid" = {
          file = "${mysecrets}/secrets/sing-box-uuid.age";
        }
        // high_security;

        "sing-box-private-key" = {
          file = "${mysecrets}/secrets/sing-box-private-key.age";
        }
        // high_security;

        "sing-box-short-id" = {
          file = "${mysecrets}/secrets/sing-box-short-id.age";
        }
        // high_security;

        "sing-box-public-key" = {
          file = "${mysecrets}/secrets/sing-box-public-key.age";
        }
        // high_security;

        "sing-box-hy2-pass" = {
          file = "${mysecrets}/secrets/sing-box-hy2-pass.age";
        }
        // high_security;
      };
    })

  ];
}
