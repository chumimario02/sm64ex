#!/bin/bash
# Super Mario 64 (sm64ex) - compilación cruzada ARM64 desde Linux x86_64.
#
# Uso:
#   ./build-pi-cross.sh
#
# Requisitos (Ubuntu/Debian/WSL):
#   sudo dpkg --add-architecture arm64 && sudo apt update
#   sudo apt install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
#                       libsdl2-dev:arm64 libgles2-mesa-dev:arm64 \
#                       libegl1-mesa-dev:arm64 pkg-config
#
# Necesitas tu propia ROM legal de Super Mario 64 (US) como baserom.us.z64.

set -eu
cd "$(dirname "$0")"

JOBS="${JOBS:-8}"

if [ ! -f baserom.us.z64 ]; then
  echo "ERROR: falta baserom.us.z64 (tu ROM legal de Super Mario 64 US)."
  exit 1
fi

# Herramientas del build: se compilan para el host x86_64.
make -C tools -j1 CC=gcc CXX=g++

# Motor + assets para ARM64 (Pi Zero 2 W / Pi 3 / Pi 4).
make BUILD_DIR_BASE=build-pi TARGET_RPI=1 TARGET_BITS=0 \
     CC=aarch64-linux-gnu-gcc CXX=aarch64-linux-gnu-g++ \
     OPT_FLAGS='-O3 -march=armv8-a+crc -mtune=cortex-a53' \
     -j"$JOBS"

echo
echo "OK: build-pi/us_pc/sm64.us.f3dex2e.arm (ELF aarch64)"
echo "Cópialo a la Pi junto a este LEEME y ejecútalo."
