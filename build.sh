#!/bin/bash
set -e

ABI_LIST=("arm64-v8a" "armeabi-v7a")
NDK_LIST=("r16b" "r25c" "r27")

SRC_DIR=input
OUT=output

mkdir -p $OUT

SRC_FILE=$(find $SRC_DIR -name "*.cpp" | head -n 1)

for NDK in "${NDK_LIST[@]}"; do
  export ANDROID_NDK_HOME=/opt/android-ndk-$NDK
  TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64

  for ABI in "${ABI_LIST[@]}"; do
    case $ABI in
      arm64-v8a)
        TARGET=aarch64-linux-android21
        ;;
      armeabi-v7a)
        TARGET=armv7a-linux-androideabi16
        ;;
    esac

    mkdir -p $OUT/$NDK/$ABI

    $TOOLCHAIN/bin/clang++ \
      -shared -fPIC \
      $SRC_FILE \
      -o $OUT/$NDK/$ABI/libnative.so \
      --target=$TARGET
  done
done
