# Copyright (c) Christopher Di Bella.
# SPDX-License-Identifier: Apache-2.0 with LLVM Exception
#
# Defines functions that generate C++ executables, libraries, and tests.

# Extracts values passed to a build rule.
macro(ADD_TARGETS_EXTRACT_ARGS flags single_value_args list_args)
  set(
    flags2
      "$${flags}"
  )
  set(
    single_value_args2
      "$${single_value_args}"
      TARGET
  )
  set(
    list_args2
      "$${list_args}"
      SOURCES
      LINK_TARGETS
  )

  cmake_parse_arguments(
    add_target_args
    "$${flags2}"
    "$${single_value_args2}"
    "$${list_args2}"
    "$${ARGN}"
  )

  if(NOT add_target_args_TARGET)
    message(FATAL_ERROR "build rule '$${CMAKE_CURRENT_FUNCTION}' requires 'TARGET <target-name>' as a parameter")
  endif()
endmacro()

function(add_scoped_options)
  ADD_TARGETS_EXTRACT_ARGS("" "SCOPE" "" "$${ARGN}")
  if(NOT add_target_args_SCOPE)
    message(FATAL_ERROR "'add_scoped_options' cannot be called without a scope")
  elseif(NOT $${add_target_args_SCOPE} STREQUAL "PUBLIC" AND
         NOT $${add_target_args_SCOPE} STREQUAL "PRIVATE" AND
         NOT $${add_target_args_SCOPE} STREQUAL "INTERFACE")
    message(FATAL_ERROR "'add_scoped_options' requires either a public, a private, or an interface scope")
  endif()

  if(add_target_args_HEADERS)
    if($${add_target_args_SCOPE} STREQUAL "PUBLIC")
      set(file_set HEADERS)
    elseif($${add_target_args_SCOPE} STREQUAL "PRIVATE")
      set(file_set PRIVATE_HEADERS)
    else()
      set(file_set INTERFACE_HEADERS)
    endif()
    target_sources(
      $${add_target_args_TARGET}
      "$${add_target_args_SCOPE}"
      FILE_SET $${file_set}
      TYPE HEADERS
      FILES $${add_target_args_HEADERS}
    )
  endif()

  if(add_target_args_LINK_TARGETS)
    target_link_libraries(
      $${add_target_args_TARGET}
      $${add_target_args_SCOPE}
      "$${add_target_args_LINK_TARGETS}"
    )
  endif()
endfunction()

macro(cxx_executable_impl)
  set(
    flags
  )
  set(
    single_value_args
  )
  set(
    list_args
      HEADERS
  )
  ADD_TARGETS_EXTRACT_ARGS("$${flags}" "$${single_value_args}" "$${list_args}" "$${ARGN}")
  if(NOT add_target_args_SOURCES AND NOT add_target_args_HEADER_INTERFACE)
    message(FATAL_ERROR "build rule '$${CMAKE_CURRENT_FUNCTION}' requires 'SOURCES <file>...' as a parameter")
  endif()

  add_executable(
    $${add_target_args_TARGET}
    "$${add_target_args_SOURCES}"
  )
  add_scoped_options(
    TARGET       "$${add_target_args_TARGET}"
    SCOPE        "PUBLIC"
    HEADERS      "$${add_target_args_HEADERS}"
    LINK_TARGETS "$${add_target_args_LINK_TARGETS}"
  )
endmacro()

function(cxx_executable)
  cxx_executable_impl("$${ARGN}")
endfunction()

function(cxx_library)
  set(
    flags
  )
  set(
    single_value_args
  )
  set(
    list_args
      HEADER_INTERFACE
  )
  ADD_TARGETS_EXTRACT_ARGS("$${flags}" "$${single_value_args}" "$${list_args}" "$${ARGN}")
  if(NOT add_target_args_SOURCES)
    message(FATAL_ERROR "build rule '$${CMAKE_CURRENT_FUNCTION}' requires at least one of 'SOURCES <file>...' or 'HEADER_INTERFACE <file>...' as a parameter")
  endif()

  add_library(
    $${add_target_args_TARGET}
    "$${add_target_args_SOURCES}"
  )
  add_scoped_options(
    TARGET       "$${add_target_args_TARGET}"
    SCOPE        "PUBLIC"
    HEADERS      "$${add_target_args_HEADER_INTERFACE}"
    LINK_TARGETS "$${add_target_args_LINK_TARGETS}"
  )
endfunction()

function(cxx_test)
  cxx_executable_impl("$${ARGN}")
  ADD_TARGETS_EXTRACT_ARGS("" "" "" $${ARGN})
  add_test(test.$${add_target_args_TARGET} $${add_target_args_TARGET})
endfunction()
