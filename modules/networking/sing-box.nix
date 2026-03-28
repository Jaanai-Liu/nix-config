{
  config,
  pkgs,
  myvars,
  ...
}:

{
  services.sing-box.settings = {
    experimental.clash_api = {
      external_controller = "127.0.0.1:9090";
      external_ui = "ui"; # 如果你装了面板包的话
      external_ui_download_url = "https://github.com/MetaCubeX/Yacd-meta/archive/gh-pages.zip";
      external_ui_download_detour = "proxy";
    };

    inbounds = [
      {
        type = "tun";
        tag = "tun-in";
        interface_name = "tun0";
        inet4_address = "172.19.0.1/30";
        auto_route = true;
        strict_route = true;
        stack = "system";
        sniff = true;
      }
    ];

    outbounds = [
      {
        type = "vless";
        tag = "RackNerd-LA-Reality";
        server = "23.95.28.22";
        server_port = 443;
        uuid._secret = config.age.secrets."sing-box-uuid".path;
        flow = "xtls-rprx-vision";
        tls = {
          enabled = true;
          server_name = "www.microsoft.com";
          utls = {
            enabled = true;
            fingerprint = "chrome";
          };
          reality = {
            enabled = true;
            public_key = "7hL_zW7GbK8Tu2omBBEbCIUQXD8mVVFTzm9OlSdQbB0";
            short_id._secret = config.age.secrets."sing-box-short-id".path;
          };
        };
      }

      {
        type = "selector";
        tag = "🚀 Global Proxy";
        outbounds = [
          "RackNerd-LA-Reality"
          "direct"
        ];
      }

      {
        type = "selector";
        tag = "🍎 Apple Service";
        outbounds = [
          "direct"
          "🚀 Global Proxy"
        ];
      }

      # 基础出口
      {
        type = "direct";
        tag = "direct";
      }
      {
        type = "block";
        tag = "block";
      }
      {
        type = "dns";
        tag = "dns-out";
      }
    ];

    route = {
      rule_set = [
        {
          tag = "geosite-cn";
          type = "remote";
          format = "binary";
          url = "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-cn.srs";
          download_detour = "RackNerd-LA-Reality";
        }
        {
          tag = "geosite-apple";
          type = "remote";
          format = "binary";
          url = "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-apple.srs";
          download_detour = "RackNerd-LA-Reality";
        }
        {
          tag = "geosite-google";
          type = "remote";
          format = "binary";
          url = "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-google.srs";
          download_detour = "RackNerd-LA-Reality";
        }
        {
          tag = "geoip-cn";
          type = "remote";
          format = "binary";
          url = "https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set/geoip-cn.srs";
          download_detour = "RackNerd-LA-Reality";
        }
      ];

      rules = [
        # DNS 请求优先处理
        {
          protocol = "dns";
          outbound = "dns-out";
        }

        # 局域网直连 (对应 private/lancidr)
        {
          ip_is_private = true;
          outbound = "direct";
        }

        # 苹果服务走专属策略组 (对应 icloud/apple)
        {
          rule_set = [ "geosite-apple" ];
          outbound = "🍎 Apple Service";
        }

        # Google 走代理 (对应 google)
        {
          rule_set = [ "geosite-google" ];
          outbound = "🚀 Global Proxy";
        }

        # 国内域名和 IP 直连 (对应 direct/cncidr)
        {
          rule_set = [
            "geosite-cn"
            "geoip-cn"
          ];
          outbound = "direct";
        }

        # 最后的兜底规则：走全局代理策略组 (对应 Final Match)
      ];
      auto_detect_interface = true;
      final = "🚀 Global Proxy";
    };
  };
}
