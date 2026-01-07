# NixOS Config

## Setup for private laptop "spruce"

```
git clone git@github.com:owickstrom/nixos
cd nixos
sudo nix-build switch --flake '.#spruce'
```

## Setup for work laptop "antithesis-laptop"

```
git clone git@github.com:owickstrom/nixos /tmp/nixos
sudo mv /tmp/nixos /etc/nixos/personal
chown $(whoami) /etc/nixos/personal
nix-build switch --flake '.#spruce'
sudo nixos-rebuild switch --flake '/etc/nixos/personal#antithesis-laptop' --impure --option substituters 'https://cache.nixos.org'
```
