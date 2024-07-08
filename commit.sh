#! /usr/bin/env nix-shell
#! nix-shell -i bash -p git

if [ -z "$1" ]; then
    echo "Please provide config name (i.e default / lapotop)"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Please provide a comit message"
    exit 1
fi

cd ~/nix
git add .
git commit -m "$2"
sudo nixos-rebuild switch --flake "/home/maticzpl/nix#$1" -p "$(date +'%Y-%m-%d_%H-%M-%S_')${2// /-}"
