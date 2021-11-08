#!/bin/sh
# Build system config.
# pushd ~/.dotfiles
sudo nixos-rebuild boot --flake .#
# popd
