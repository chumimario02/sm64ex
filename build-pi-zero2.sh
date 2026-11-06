#!/bin/bash
# Super Mario 64 (sm64ex) - build nativo para Raspberry Pi Zero 2 W
#
# Uso:
#   ./build-pi-zero2.sh
#
# Requisitos (Raspberry Pi OS 32-bit o 64-bit):
#   sudo apt update
#   sudo apt install -y build-essential git python3 libsdl2-dev \
#                       libgles2-mesa-dev libegl1-mesa-dev
#
# Necesitas tu propia ROM legal de Super Mario 64 (US) como baserom.us.z64
# en la raíz de este repositorio.
#
# El script usa -j1 para no quedarse sin RAM en la Pi Zero 2 W (512 MB).
# Si tienes swap suficiente puedes probar: JOBS=2 ./build-pi-zero2.sh

set -eu
cd "$(dirname "$0")"

JOBS="${JOBS:-1}"

if [ ! -f baserom.us.z64 ]; then
  echo "ERROR: falta baserom.us.z64 (tu ROM legal de Super Mario 64 US)."
  echo "Cópiala en: $(pwd)/baserom.us.z64"
  exit 1
fi

model="$(tr -d '\0' < /sys/firmware/devicetree/base/model 2>/dev/null || echo unknown)"
arch="$(uname -m)"
echo "Pi detectada: $model ($arch)"
echo "Compilando con $JOBS job(s)... (puede tardar bastante)"

# TARGET_RPI=1 activa GLES2 y el título/hints de Raspberry Pi.
# -O3 + -mtune=cortex-a53 los aplica el Makefile al detectar Zero 2 W.
make TARGET_RPI=1 -j"$JOBS"

echo
echo "OK: binario en build/sm64.us.f3dex2e (o similar)."
echo "Cópialo junto a su carpeta res/ y ejecútalo desde esa carpeta."
echo
echo "Consejo para Zero 2 W: en sm64config.txt usa 640x480 y fullscreen=1."
