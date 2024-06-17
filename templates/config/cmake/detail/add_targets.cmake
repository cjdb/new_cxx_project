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
      DEFINE
      HEADERS
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
      set(file_set private_headers)
    else()
      set(file_set interface_headers)
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

  if(add_target_args_DEFINE)
    target_compile_definitions($${add_target_args_TARGET} $${add_target_args_SCOPE} "$${add_target_args_DEFINE}")
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
    DEFINE       "$${add_target_args_DEFINE}"
  )
endmacro()

function(cxx_executable)
  cxx_executable_impl("$${ARGN}")
endfunction()

function(library_type_error target type actual expected)
  set(diagnostic "cxx_library '$${target}' specifies '$${actual}', which is incompatible with its library type, '$${type}'")
  if(expected)
    string(APPEND diagnostic "\ndid you mean '$${expected}'?")
  endif()

  message(SEND_ERROR "$${diagnostic}")
endfunction()

macro(check_library_type)
  set(valid_types STATIC SHARED PLUGIN OBJECT HEADER_ONLY)
  list(FIND valid_types "$${add_target_args_LIBRARY_TYPE}" library_type_result)
  if(library_type_result EQUAL -1)
    if(add_target_args_LIBRARY_TYPE)
      message(FATAL_ERROR "cxx_library '$${add_target_args_TARGET}' uses unknown library type '$${add_target_args_LIBRARY_TYPE}'")
    else()
      message(FATAL_ERROR "cxx_library '$${add_target_args_TARGET}' does not specify a LIBRARY_TYPE")
    endif()
  elseif(add_target_args_LIBRARY_TYPE STREQUAL "PLUGIN")
    set(add_target_args_LIBRARY_TYPE "MODULE")
  endif()

  if(add_target_args_LIBRARY_TYPE STREQUAL "HEADER_ONLY")
    if(add_target_args_SOURCES)
      library_type_error(
        $${add_target_args_TARGET}
        $${add_target_args_LIBRARY_TYPE}
        "SOURCES"
        "HEADER_INTERFACE"
      )
    endif()
    if(add_target_args_HEADERS)
      library_type_error(
        $${add_target_args_TARGET}
        $${add_target_args_LIBRARY_TYPE}
        "HEADERS"
        "HEADER_INTERFACE"
      )
    endif()
  endif()

  if(add_target_args_LIBRARY_TYPE STREQUAL "OBJECT")
    if(add_target_args_HEADER_INTERFACE)
      library_type_error(
        $${add_target_args_TARGET}
        $${add_target_args_LIBRARY_TYPE}
        "HEADER_INTERFACE"
        "HEADERS"
      )
    endif()
  endif()
endmacro()

function(cxx_library)
  set(
    flags
  )
  set(
    single_value_args
      LIBRARY_TYPE
  )
  set(
    list_args
      HEADER_INTERFACE
  )
  ADD_TARGETS_EXTRACT_ARGS("$${flags}" "$${single_value_args}" "$${list_args}" "$${ARGN}")
  if(NOT add_target_args_SOURCES AND NOT add_target_args_HEADER_INTERFACE)
    message(FATAL_ERROR "build rule '$${CMAKE_CURRENT_FUNCTION}' requires at least one of 'SOURCES <file>...' or 'HEADER_INTERFACE <file>...' as a parameter")
  endif()

  check_library_type(
    TARGET           $${add_target_args_TARGET}
    LIBRARY_TYPE     $${add_target_args_LIBRARY_TYPE}
    SOURCES          $${add_target_args_SOURCES}
    HEADERS          $${add_target_args_HEADERS}
    HEADER_INTERFACE $${add_target_args_HEADER_INTERFACE}
  )
  if($${add_target_args_LIBRARY_TYPE} STREQUAL "HEADER_ONLY")
    add_library($${add_target_args_TARGET} INTERFACE)
  else()
    add_library(
      $${add_target_args_TARGET}
      $${add_target_args_LIBRARY_TYPE}
      "$${add_target_args_SOURCES}"
    )
  endif()
  add_scoped_options(
    SCOPE        "PUBLIC"
    TARGET       "$${add_target_args_TARGET}"
    HEADERS      "$${add_target_args_HEADER_INTERFACE}"
    DEFINE       "" # deliberately empty
  )
  add_scoped_options(
    SCOPE        "PRIVATE"
    TARGET       "$${add_target_args_TARGET}"
    HEADERS      "$${add_target_args_HEADERS}"
    LINK_TARGETS "$${add_target_args_LINK_TARGETS}"
    DEFINE       "$${add_target_args_DEFINE}"
  )
endfunction()

function(cxx_test)
  cxx_executable_impl("$${ARGN}")
  ADD_TARGETS_EXTRACT_ARGS("" "" "" $${ARGN})
  add_test(test.$${add_target_args_TARGET} $${add_target_args_TARGET})
endfunction()
