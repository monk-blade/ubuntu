#!/bin/sh

set -e
SDIR="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

chezmoi="chezmoi"
bw="bw"
if [ ! $(command -v chezmoi) ]; then
    echo "################################################################################"
    echo "### chezmoi installation"
    echo "################################################################################"
    if [ "$(command -v brew)" ]; then
        brew install chezmoi
        chezmoi="/opt/homebrew/bin/chezmoi"
    elif [ "$(command -v pacman)" ]; then
        sudo pacman -Sy --noconfirm chezmoi
    elif [ "$(command -v curl)" ]; then
        chezmoi="$HOME/.local/bin/chezmoi"
        mkdir -p "$HOME/.local/bin"
        sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$HOME/.local/bin"
    elif [ "$(command -v wget)" ]; then
        chezmoi="$HOME/.local/bin/chezmoi"
        mkdir -p "$HOME/.local/bin"
        sh -c "$(wget -qO- https://git.io.chezmoi)" -- -b "$HOME/.local/bin"
    else
        echo "No chezmoi installation method available (install curl or wget)"
        exit 1
    fi
fi

if [ ! $(command -v bw) ]; then
    echo "################################################################################"
    echo "### bitwarden installation"
    echo "################################################################################"
    if [ "$(command -v brew)" ]; then
        brew install bitwarden-cli
        bw="/opt/homebrew/bin/bw"
    elif [ "$(command -v pacman)" ]; then
        sudo pacman -Sy --noconfirm bitwarden-cli
    elif [ "$(command -v curl)" ]; then
        bw="$HOME/.local/bin/bw"
        curl -sSLO "${bw}.zip" 'https://vault.bitwarden.com/download/?app=cli&platform=linux'
    elif [ "$(command -v wget)" ]; then
        bw="$HOME/.local/bin/bw"
        wget -qO "${bw}.zip" 'https://vault.bitwarden.com/download/?app=cli&platform=linux'
    else
        echo "No bw installation method available (install curl or wget)"
        exit 1
    fi
fi

if [ -e "${bw}.zip " ]; then
    pushd "$HOME/.local/bin" >/dev/null
    unzip "${bw}.zip"
    rm -f "${bw}.zip"
    chmod +x "${bw}"
    popd >/dev/null
fi

echo "################################################################################"
echo "### bitwarden configuration"
echo "################################################################################"
while ! bw login --check; do
    read -p "Bitwarden server: " server
    if [ -n "${server}" ]; then
        $bw config server "$server"
    fi
    $bw login
done
while ! $bw unlock --check; do
    export BW_SESSION=$(bw unlock --raw)
done

echo "################################################################################"
echo "### chezmoi initialization"
echo "################################################################################"
exec "$chezmoi" init --apply "--source=${SDIR}"