#!/bin/sh
cd $HOME
mkdir -p $HOME/local
mkdir -p $HOME/cmake
mkdir -p $HOME/cmake/src
mkdir -p $HOME/cmake/bin
cd $HOME/cmake/src
wget http://www.cmake.org/files/v2.8/cmake-2.8.10.tar.gz
tar -xzf cmake-2.8.10.tar.gz
cd $HOME/cmake/bin
$HOME/cmake/src/cmake-2.8.10/configure --prefix=$HOME/local
make -j4
make install
