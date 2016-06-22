#!/bin/bash

echo "--- Removing any pre-installed ffmpeg and x264"
apt-get -qq remove ffmpeg x264 libx264-dev

function install_dependency {
    echo "--- Installing dependency: $1"
    apt-get -y install $1 --no-install-recommends
}

install_dependency build-essential
install_dependency checkinstall
install_dependency cmake
install_dependency pkg-config
install_dependency unzip

