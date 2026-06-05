# home/gui/daily/rustdesk.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustdesk-flutter
  ];

  xdg.configFile."rustdesk/RustDesk2.toml" = {
    text = ''
      rendezvous_server = '10.126.0.1:21116'
      nat_type = 2
      serial = 0

      [options]
      relay-server = '10.126.0.1'
      custom-rendezvous-server = '10.126.0.1'
      key = 'TwDpmWPiMDSIWZTl+HPvU18VqPHerADQcvpq1PMgQZI='
      api-server = 'http://10.126.0.1:21114'
      av1-test = 'Y'
    '';
  };
}
