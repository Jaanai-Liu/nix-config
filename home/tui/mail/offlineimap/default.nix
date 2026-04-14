{
  config,
  pkgs,
  lib,
  ...
}:

let
  secretPath = "${config.home.homeDirectory}/.config/mail-secrets";

  pythonFile = ''
    #! /usr/bin/env python
    import os

    def get_pass(account):
        filepath = f"${secretPath}/{account.lower()}"
        try:
            with open(filepath, 'r') as file:
                return file.read().strip()
        except FileNotFoundError:
            return f"Error: Password file not found for {account}"
  '';
  offlineimapPkg = pkgs.offlineimap;
in
{
  home.packages = [ offlineimapPkg ];
  xdg.configFile."offlineimap/get_settings.py".text = pythonFile;
  xdg.configFile."offlineimap/get_settings.pyc".source = "${
    pkgs.runCommandLocal "get_settings-compile"
      {
        nativeBuildInputs = [ offlineimapPkg ];
        pythonCode = pythonFile;
        passAsFile = [ "pythonCode" ];
      }
      ''
        mkdir -p $out/bin
        cp $pythonCodePath $out/bin/get_settings.py
        python -m py_compile $out/bin/get_settings.py
      ''
  }/bin/get_settings.pyc";
}
