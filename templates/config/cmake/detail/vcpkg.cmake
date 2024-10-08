# Copyright Christopher Di Bella
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See /LICENCE for licence information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
execute_process(
  COMMAND "$${CMAKE_CXX_COMPILER}" -dumpmachine
  COMMAND tr -d '\n'
  OUTPUT_VARIABLE _${PROJECT_NAME}_TARGET_TRIPLE
)

if(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^x86_64")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "x64")
elseif(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^x86")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "x86")
elseif(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^arm64")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "arm64")
elseif(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^arm")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "arm")
elseif(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^aarch64")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "aarch64")
elseif(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^loongarch32")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "loongarch32")
elseif(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^loongarch64")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "loongarch64")
elseif(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^riscv32")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "riscv32")
elseif(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^riscv64")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "riscv64")
elseif(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^s390x")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "s390x")
elseif(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^mips64")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "mips64")
elseif(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^ppc64le")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "ppc64le")
elseif(_${PROJECT_NAME}_TARGET_TRIPLE MATCHES "^wasm32")
  set(_${PROJECT_NAME}_TARGET_ARCHITECTURE "wasm32")
else()
  message(FATAL_ERROR "Can't generate vcpkg toolchain file because $${_${PROJECT_NAME}_TARGET_TRIPLE} doesn't have a known architecture mapping")
endif()

set(${PROJECT_NAME}_CRT_LINKAGE static)
set(${PROJECT_NAME}_LIBRARY_LINKAGE static)

configure_file(
  "$${CMAKE_CURRENT_LIST_DIR}/vcpkg_toolchain_file.cmake.in"
  "$${CMAKE_BINARY_DIR}/vcpkg_toolchain_file.cmake"
  @ONLY
)
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "$${CMAKE_BINARY_DIR}/vcpkg_toolchain_file.cmake")
include("$${PROJECT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake")
