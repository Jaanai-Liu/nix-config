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
    server.siyuan.enable = mkEnableOption "NixOS Secrets for SiYuan Server";
    server.web-server.enable = mkEnableOption "NixOS Secrets for Web Server";
  };

  config = mkMerge [

    # ==========================================
    # 🖥️ 【台式机专区】只有开启 desktop.enable 才加载
    # ==========================================
    (mkIf cfg.desktop.enable {
      environment.systemPackages = [
        agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
      ];

      # age.identityPaths = [ "/persistent/etc/ssh/ssh_host_ed25519_key" ];
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      age.secrets = {
        "ssh-key.age" = {
          file = "${mysecrets}/secrets/ssh-key-${config.networking.hostName}.age";
        }
        // user_readable;

        "github-token" = {
          file = "${mysecrets}/secrets/github-token.age";
        }
        // high_security;

        "rclone-openlist" = {
          file = "${mysecrets}/secrets/rclone-openlist.age";
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

        # Mail password
        "pass-gmail" = {
          file = "${mysecrets}/secrets/pass-gmail.age";
          path = "/home/${myvars.username}/.config/mail-secrets/gmail";
        }
        // user_readable;
        "pass-qqmail" = {
          file = "${mysecrets}/secrets/pass-qqmail.age";
          path = "/home/${myvars.username}/.config/mail-secrets/qq";
        }
        // user_readable;
        "pass-163mail" = {
          file = "${mysecrets}/secrets/pass-163mail.age";
          path = "/home/${myvars.username}/.config/mail-secrets/163";
        }
        // user_readable;
        "pass-swjtu-mail" = {
          file = "${mysecrets}/secrets/pass-swjtu-mail.age";
          path = "/home/${myvars.username}/.config/mail-secrets/swjtu";
        }
        // user_readable;

        # Mail client config
        "offlineimaprc" = {
          file = "${mysecrets}/secrets/offlineimaprc.age";
          path = "/home/${myvars.username}/.offlineimaprc";
        }
        // user_readable;
        "goimapnotify-yaml" = {
          file = "${mysecrets}/secrets/goimapnotify.yaml.age";
          path = "/home/${myvars.username}/.config/goimapnotify/goimapnotify.yaml";
        }
        // user_readable;
        "aerc-accounts" = {
          file = "${mysecrets}/secrets/aerc-accounts.conf.age";
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

    # ==========================================
    # 📓 SiYuan Server Secrets
    # ==========================================
    (mkIf cfg.server.siyuan.enable {
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      age.secrets = {
        "siyuan-server-env" = {
          file = "${mysecrets}/secrets/siyuan-server-env.age";
        }
        // high_security;
      };
    })

    # ==========================================
    # 🌐 Web Server Secrets
    # ==========================================
    (mkIf cfg.server.web-server.enable {
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      age.secrets = {
        "cf-tunnel-env" = {
          file = "${mysecrets}/secrets/cf-tunnel-env.age";
        }
        // high_security;
      };
    })
  ];
}
