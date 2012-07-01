#!/bin/sh
cd $HOME
mkdir -p cmake
mkdir -p cmake/src
mkdir -p cmake/bin
cd $HOME/cmake/src
wget http://www.cmake.org/files/v2.8/cmake-2.8.8.tar.gz
tar -xzf cmake-2.8.8.tar.gz
cd $HOME/cmake/bin
../cmake-2.8.8/configure

