<h2 align="center">:snowflake: Jaanai-Liu's Nix Config :snowflake:</h2>

<p align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="400" />
</p>

<p align="center">
	<a href="https://github.com/Jaanai-Liu/nix-config/stargazers">
		<img alt="Stargazers" src="https://img.shields.io/github/stars/Jaanai-Liu/nix-config?style=for-the-badge&logo=starship&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41"></a>
    <a href="https://nixos.org/">
        <img src="https://img.shields.io/badge/NixOS-25.11-informational.svg?style=for-the-badge&logo=nixos&color=F2CDCD&logoColor=D9E0EE&labelColor=302D41"></a>
    <a href="https://github.com/Jaanai-Liu/nixos-and-flakes-book">
        <img src="https://img.shields.io/badge/Nix%20Flakes-learning-informational.svg?style=for-the-badge&logo=nixos&color=F2CDCD&logoColor=D9E0EE&labelColor=302D41"></a>
  </a>
</p>

> My configuration is becoming more and more complex, and **it will be difficult for beginners to
> read**. If you are new to NixOS and want to know how I use NixOS, I would recommend you to take a
> look at the [Jaanai-Liu/nix-config/releases](https://github.com/Jaanai-Liu/nix-config/releases) first,
> **check out to some simpler older versions, such as
> [i3-kickstarter](https://github.com/Jaanai-Liu/nix-config/tree/i3-kickstarter), which will be much
> easier to understand**.

This repository is home to the nix code that builds my systems: NixOS with home-manager, niri, agenix, etc.

## Components

|                                                                | NixOS(Wayland)                                                                                                      |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| **Window Manager**                                             | [Niri][Niri]                                                                                                        |
| **Terminal Emulator**                                          | [Zellij][Zellij] + [Kitty][Kitty]           |
| **Status Bar** / **Notifier** / **Launcher** / **lockscreens** | [noctalia-shell][noctalia-shell]                                                                                    |
| **Display Manager**                                            | [tuigreet][tuigreet]                                                                                                |
| **Input method framework**                                     | [Fcitx5][Fcitx5] + [rime][rime]            |
| **System resource monitor**                                    | [Btop][Btop]                                                                                                        |
| **File Manager**                                               | [Yazi][Yazi]     nnn     |
| **Shell**                                                      | [zsh] + [Starship][Starship]                                                                           |
| **Media Player**                                               | [mpv][mpv]                                                                                                          |
| **Text Editor**                                                | [Neovim][Neovim]                                                                                                    |
| **Image Viewer**                                               | [imv][imv]                                                                                                          |
| **Screenshot Software**                                        | Niri's builtin function                                                                                             |
| **Screen Recording**                                           | [OBS][OBS]                                                                                                          |
Wallpapers: https://github.com/Jaanai-Liu/nix-config/wallpapers

## Screenshots


## Secrets Management

See [./secrets](./secrets) for details.

## How to Deploy this Flake?

<!-- prettier-ignore -->
> :red_circle: **IMPORTANT**: **You should NOT deploy this flake directly on your machine :exclamation:
> It will not succeed.** This flake contains my hardware configuration(such as
> [hardware-configuration.nix](hosts/lz-pc/hardware-configuration.nix),
> [Jaanai-Liu/nix-secrets](https://github.com/Jaanai-Liu/nix-config/tree/main/secrets) to deploy. You
> may use this repo as a reference to build your own configuration.

For NixOS:

> To deploy this flake from NixOS's official ISO image (purest installation method), please refer to
> [./nixos-installer/](./nixos-installer/)

```bash
# deploy one of the configuration based on the hostname
sudo nixos-rebuild switch --flake .#lz-pc

需要修改hosts路径下的niri文件配置output.kdl
```

> [What y'all will need when Nix drives you to drink.](https://www.youtube.com/watch?v=Eni9PPPPBpg)
> (copy from hlissner's dotfiles, it really matches my feelings when I first started using NixOS...)

## References

Other dotfiles that inspired me:

- Nix Flakes
  - [NixOS-CN/NixOS-CN-telegram](https://github.com/NixOS-CN/NixOS-CN-telegram)
  - [notusknot/dotfiles-nix](https://github.com/notusknot/dotfiles-nix)
  - [xddxdd/nixos-config](https://github.com/xddxdd/nixos-config)
  - [bobbbay/dotfiles](https://github.com/bobbbay/dotfiles)
  - [gytis-ivaskevicius/nixfiles](https://github.com/gytis-ivaskevicius/nixfiles)
  - [davidtwco/veritas](https://github.com/davidtwco/veritas)
  - [gvolpe/nix-config](https://github.com/gvolpe/nix-config)
  - [Ruixi-rebirth/flakes](https://github.com/Ruixi-rebirth/flakes)
  - [fufexan/dotfiles](https://github.com/fufexan/dotfiles): gtk theme, xdg, git, media, etc.
  - [nix-community/srvos](https://github.com/nix-community/srvos): a collection of opinionated and
    sharable NixOS configurations for servers
- Modularized NixOS Configuration
  - [hlissner/dotfiles](https://github.com/hlissner/dotfiles)
  - [viperML/dotfiles](https://github.com/viperML/dotfiles)
- Neovim/AstroNvim
  - [maxbrunet/dotfiles](https://github.com/maxbrunet/dotfiles): astronvim with nix flakes.
- Misc
  - [1amSimp1e/dots](https://github.com/1amSimp1e/dots)

[Niri]: https://github.com/YaLTeR/niri
[Kitty]: https://github.com/kovidgoyal/kitty
[foot]: https://codeberg.org/dnkl/foot
[Alacritty]: https://github.com/alacritty/alacritty
[Ghostty]: https://github.com/ghostty-org/ghostty
[Nushell]: https://github.com/nushell/nushell
[Starship]: https://github.com/starship/starship
[Fcitx5]: https://github.com/fcitx/fcitx5
[rime]: https://wiki.archlinux.org/title/Rime
[flypy]: https://flypy.cc/
[Btop]: https://github.com/aristocratos/btop
[mpv]: https://github.com/mpv-player/mpv
[Zellij]: https://github.com/zellij-org/zellij
[Neovim]: https://github.com/neovim/neovim
[AstroNvim]: https://github.com/AstroNvim/AstroNvim
[imv]: https://sr.ht/~exec64/imv/
[OBS]: https://obsproject.com
[Nerd fonts]: https://github.com/ryanoasis/nerd-fonts
[catppuccin-nix]: https://github.com/catppuccin/nix
[NetworkManager]: https://wiki.gnome.org/Projects/NetworkManager
[wl-clipboard]: https://github.com/bugaevc/wl-clipboard
[tuigreet]: https://github.com/apognu/tuigreet
[thunar]: https://gitlab.xfce.org/xfce/thunar
[Yazi]: https://github.com/sxyazi/yazi
[Catppuccin]: https://github.com/catppuccin/catppuccin
[Btrfs]: https://btrfs.readthedocs.io
[LUKS]: https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system
[lanzaboote]: https://github.com/nix-community/lanzaboote
[noctalia-shell]: https://github.com/noctalia-dev/noctalia-shell
