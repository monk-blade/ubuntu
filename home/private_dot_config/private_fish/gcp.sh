#!/bin/bash

# Developer packages
gcp_packages=(
    "cmake"
    "git"
    "g++"
    "protobuf-compiler"
    "libprotobuf-dev"
    "fcitx5-modules-dev"
    "libfcitx5config-dev"
    "libfcitx5core-dev"
    "libfcitx5utils-dev"
    "libzmq3-dev"
    # add more developer packages here
)

# Function to install apt packages
install_apt_packages() {
    local packages=("$@")
    for package in "${packages[@]}"; do
        if ! dpkg-query -W -f='${Status} ${Package}\n' | grep -q "^install ok installed $package$"; then
            sudo apt install -y "$package"
        else
            echo "$package is already installed."
        fi
    done
}

# Function to install libzmq from source
install_libzmq() {
    if ! ldconfig -p | grep -q libzmq; then
        curl -L -o zeromq-4.3.5.tar.gz https://github.com/zeromq/libzmq/releases/download/v4.3.5/zeromq-4.3.5.tar.gz
        if [ -d "zeromq-4.3.5" ]; then
            rm -rf zeromq-4.3.5
        fi
        tar -xzf zeromq-4.3.5.tar.gz
        cd zeromq-4.3.5
        mkdir build && cd build
        cmake ..
        sudo make -j4 install
        sudo ldconfig
        cd ../..
    else
        echo "libzmq is already installed."
    fi
}

# Function to install cppzmq from source
install_cppzmq() {
    if ! ldconfig -p | grep -q libzmq; then
        echo "libzmq must be installed before installing cppzmq."
        install_libzmq
    fi
    if ! ldconfig -p | grep -q cppzmq; then
        curl -L -o cppzmq-4.10.0.tar.gz https://github.com/zeromq/cppzmq/archive/refs/tags/v4.10.0.tar.gz
        if [ -d "cppzmq-4.10.0" ]; then
            rm -rf cppzmq-4.10.0
        fi
        tar -xzf cppzmq-4.10.0.tar.gz
        cd cppzmq-4.10.0/
        mkdir build && cd build
        cmake ..
        sudo make -j4 install
        sudo ldconfig
        cd ../..
        rm -rf cppzmq-4.10.0 cppzmq-4.10.0.tar.gz
    else
        echo "cppzmq is already installed."
    fi
}
install_apt_packages "${gcp_packages[@]}"
install_cppzmq

