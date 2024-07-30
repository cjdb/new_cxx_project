# Copyright Christopher Di Bella
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See /LICENCE for licence information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
execute_process(
  COMMAND "${CMAKE_CXX_COMPILER}" -dumpmachine
  COMMAND tr -d '\n'
  OUTPUT_VARIABLE _COPIED_OKAY_TARGET_TRIPLE
)

if(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^x86_64")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "x64")
elseif(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^x86")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "x86")
elseif(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^arm64")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "arm64")
elseif(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^arm")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "arm")
elseif(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^aarch64")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "aarch64")
elseif(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^loongarch32")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "loongarch32")
elseif(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^loongarch64")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "loongarch64")
elseif(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^riscv32")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "riscv32")
elseif(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^riscv64")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "riscv64")
elseif(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^s390x")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "s390x")
elseif(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^mips64")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "mips64")
elseif(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^ppc64le")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "ppc64le")
elseif(_COPIED_OKAY_TARGET_TRIPLE MATCHES "^wasm32")
  set(_COPIED_OKAY_TARGET_ARCHITECTURE "wasm32")
else()
  message(FATAL_ERROR "Can't generate vcpkg toolchain file because ${_COPIED_OKAY_TARGET_TRIPLE} doesn't have a known architecture mapping")
endif()

set(COPIED_OKAY_CRT_LINKAGE static)
set(COPIED_OKAY_LIBRARY_LINKAGE static)

configure_file(
  "${CMAKE_CURRENT_LIST_DIR}/vcpkg_toolchain_file.cmake.in"
  "${CMAKE_BINARY_DIR}/vcpkg_toolchain_file.cmake"
  @ONLY
)
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_BINARY_DIR}/vcpkg_toolchain_file.cmake")
include("${PROJECT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake")
