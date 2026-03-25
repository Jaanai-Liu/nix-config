{
  description = "Jaanai-Liu's flake!";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; # 使用相同的 nixpkgs
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11"; # 匹配你的 25.11 版本
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Agenix - secrets manager
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs"; # 让它使用你系统的 nixpkgs，节省空间
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
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
  };

  outputs = inputs: import ./outputs inputs;
}
