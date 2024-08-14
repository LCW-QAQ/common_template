#!/bin/bash
packages=(
mingw-w64-x86_64-tbb
mingw-w64-x86_64-jsoncpp
mingw-w64-x86_64-yaml-cpp
mingw-w64-x86_64-cpr

mingw-w64-x86_64-poco
mingw-w64-x86_64-unixodbc
mingw-w64-x86_64-soci

mingw-w64-x86_64-cppzmq
)

echo packages: ${packages[@]}

for pkg in ${packages[@]}
do
  echo install $pkg
  pacman -S --noconfirm $pkg
done