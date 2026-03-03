{
  description = "lz's flake! PS: A very basic flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";


    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";  # 使用相同的 nixpkgs
    };

    # Agenix - secrets manager
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ########################  My own repositories  #########################################
    # my private secrets, it's a private repository, you need to replace it with your own.
    # use ssh protocol to authenticate via ssh-agent/ssh-key, and shallow clone to save time
    mysecrets = {
      url = "git+ssh://git@github.com/Jaanai-Liu/nix-secrets.git?shallow=1";
      flake = false;
    };

    # myfonts = {
    #   url = "git+ssh://git@github.com/Jaanai-Liu/nixos-fonts.git?shallow=1";
    #   flake = false;
    # };

    # niri.url = "github:YaLTeR/niri";
  };

  outputs = inputs: import ./outputs inputs;
}
