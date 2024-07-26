# Copyright (c) Christopher Di Bella.
# SPDX-License-Identifier: Apache-2.0 with LLVM Exception
#
# Defines functions that generate C++ executables, libraries, and tests.

include(GNUInstallDirs)

# Extracts values passed to a build rule.
macro(ADD_TARGETS_EXTRACT_ARGS flags single_value_args list_args)
  set(
    flags2
      "${flags}"
  )
  set(
    single_value_args2
      "${single_value_args}"
      TARGET
      INSTALL_WITH
      INSTALL_PREFIX_INCLUDE
      INSTALL_PREFIX_LIBRARY
  )
  set(
    list_args2
      "${list_args}"
      COMPILE_OPTIONS
      DEFINE
      HEADERS
      LINK_OPTIONS
      SOURCES
      DEPENDS_ON
      INSTALL_PERMISSIONS
  )

  cmake_parse_arguments(
    add_target_args
    "${flags2}"
    "${single_value_args2}"
    "${list_args2}"
    "${ARGN}"
  )

  if(NOT add_target_args_TARGET)
    message(FATAL_ERROR "build rule '${CMAKE_CURRENT_FUNCTION}' requires 'TARGET <target-name>' as a parameter")
  endif()
endmacro()

function(add_scoped_options)
  ADD_TARGETS_EXTRACT_ARGS("" "SCOPE" "" "${ARGN}")
  if(NOT add_target_args_SCOPE)
    message(FATAL_ERROR "'add_scoped_options' cannot be called without a scope")
  elseif(NOT ${add_target_args_SCOPE} STREQUAL "PUBLIC" AND
         NOT ${add_target_args_SCOPE} STREQUAL "PRIVATE" AND
         NOT ${add_target_args_SCOPE} STREQUAL "INTERFACE")
    message(FATAL_ERROR "'add_scoped_options' requires either a public, a private, or an interface scope")
  endif()

  if(add_target_args_HEADERS)
    if(NOT ${add_target_args_SCOPE} STREQUAL "PRIVATE")
      set(file_set HEADERS)
    else()
      set(file_set private_headers)
    endif()
    target_sources(
      ${add_target_args_TARGET}
      "${add_target_args_SCOPE}"
      FILE_SET ${file_set}
      TYPE HEADERS
      FILES ${add_target_args_HEADERS}
    )
  endif()

  target_link_libraries(
    ${add_target_args_TARGET}
    ${add_target_args_SCOPE}
    "${add_target_args_DEPENDS_ON}"
  )
  target_compile_definitions(
    ${add_target_args_TARGET}
    ${add_target_args_SCOPE}
    "${add_target_args_DEFINE}"
  )
  target_compile_options(
    ${add_target_args_TARGET}
    ${add_target_args_SCOPE}
    "${add_target_args_COMPILE_OPTIONS}"
  )

  foreach(option IN LISTS add_target_args_LINK_OPTIONS)
    list(APPEND options "LINKER:SHELL:${option}")
  endforeach()
  target_link_options(
    ${add_target_args_TARGET}
    ${add_target_args_SCOPE}
    "${options}"
  )

  if(add_target_args_INSTALL_WITH)
    if(add_target_args_MODULE_INTERFACE)
      message(SEND_ERROR "cxx_library '${add_target_args_TARGET}' tries to install a module interface, but tooling isn't mature enough to support installing them yet")
      return()
    endif()

    cmake_path(
      APPEND
        INSTALL_INCLUDEDIR
        "${CMAKE_INSTALL_INCLUDEDIR}"
        "${add_target_args_INSTALL_PREFIX_INCLUDE}"
    )
    cmake_path(
      APPEND
        INSTALL_LIBDIR
        "${CMAKE_INSTALL_LIBDIR}"
        "${add_target_args_INSTALL_PREFIX_LIBRARY}"
    )

    install(
      TARGETS ${add_target_args_TARGET}
      EXPORT  ${add_target_args_INSTALL_WITH}
      FILE_SET HEADERS
        DESTINATION "${INSTALL_INCLUDEDIR}"
        COMPONENT development
        PERMISSIONS ${add_target_args_INSTALL_PERMISSIONS}
      ARCHIVE
        DESTINATION "${INSTALL_LIBDIR}"
        COMPONENT development
        PERMISSIONS ${add_target_args_INSTALL_PERMISSIONS}
      LIBRARY
        DESTINATION "${INSTALL_LIBDIR}"
        COMPONENT runtime
        PERMISSIONS ${add_target_args_INSTALL_PERMISSIONS}
      RUNTIME
        DESTINATION "${CMAKE_INSTALL_BINDIR}"
        COMPONENT runtime
        PERMISSIONS ${add_target_args_INSTALL_PERMISSIONS}
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
  )
  ADD_TARGETS_EXTRACT_ARGS("${flags}" "${single_value_args}" "${list_args}" "${ARGN}")
  if(NOT add_target_args_SOURCES AND NOT add_target_args_HEADER_INTERFACE)
    message(FATAL_ERROR "build rule '${CMAKE_CURRENT_FUNCTION}' requires 'SOURCES <file>...' as a parameter")
  endif()

  add_executable(
    ${add_target_args_TARGET}
    "${add_target_args_SOURCES}"
  )

  if(add_target_args_INSTALL_WITH AND NOT add_target_args_INSTALL_PERMISSIONS)
    set(
      add_target_args_INSTALL_PERMISSIONS
        OWNER_READ
        OWNER_WRITE
        OWNER_EXECUTE
        GROUP_READ
        GROUP_EXECUTE
        WORLD_READ
        WORLD_EXECUTE
    )
  endif()

  add_scoped_options(
    TARGET                 "${add_target_args_TARGET}"
    SCOPE                  PRIVATE
    HEADERS                "${add_target_args_HEADERS}"
    DEPENDS_ON             "${add_target_args_DEPENDS_ON}"
    DEFINE                 "${add_target_args_DEFINE}"
    COMPILE_OPTIONS        "${add_target_args_COMPILE_OPTIONS}"
    LINK_OPTIONS           "${add_target_args_LINK_OPTIONS}"
    INSTALL_WITH           "${add_target_args_INSTALL_WITH}"
    INSTALL_PREFIX_INCLUDE "${add_target_args_INSTALL_PREFIX_INCLDUE}"
    INSTALL_PREFIX_LIBRARY "${add_target_args_INSTALL_PREFIX_LIBRARY}"
    INSTALL_PERMISSIONS    "${add_target_args_INSTALL_PERMISSIONS}"
  )
endmacro()

function(cxx_executable)
  cxx_executable_impl("${ARGN}")
endfunction()

function(library_type_error target type actual expected)
  set(diagnostic "cxx_library '${target}' specifies '${actual}', which is incompatible with its library type, '${type}'")
  if(expected)
    string(APPEND diagnostic "\ndid you mean '${expected}'?")
  endif()

  message(SEND_ERROR "${diagnostic}")
endfunction()

macro(check_library_type)
  set(valid_types STATIC SHARED PLUGIN OBJECT HEADER_ONLY)
  list(FIND valid_types "${add_target_args_LIBRARY_TYPE}" library_type_result)
  if(library_type_result EQUAL -1)
    if(add_target_args_LIBRARY_TYPE)
      message(FATAL_ERROR "cxx_library '${add_target_args_TARGET}' uses unknown library type '${add_target_args_LIBRARY_TYPE}'")
    else()
      message(FATAL_ERROR "cxx_library '${add_target_args_TARGET}' does not specify a LIBRARY_TYPE")
    endif()
  elseif(add_target_args_LIBRARY_TYPE STREQUAL "PLUGIN")
    set(add_target_args_LIBRARY_TYPE "MODULE")
  endif()

  if(add_target_args_LIBRARY_TYPE STREQUAL "HEADER_ONLY")
    if(add_target_args_SOURCES)
      library_type_error(
        ${add_target_args_TARGET}
        ${add_target_args_LIBRARY_TYPE}
        "SOURCES"
        "HEADER_INTERFACE"
      )
    endif()
    if(add_target_args_HEADERS)
      library_type_error(
        ${add_target_args_TARGET}
        ${add_target_args_LIBRARY_TYPE}
        "HEADERS"
        "HEADER_INTERFACE"
      )
    endif()
    if(add_target_args_COMPILE_OPTIONS)
      library_type_error(
        ${add_target_args_TARGET}
        ${add_target_args_LIBRARY_TYPE}
        "COMPILE_OPTIONS"
        ""
      )
    endif()
    if(add_target_args_DEPENDS_ON)
      library_type_error(
        ${add_target_args_TARGET}
        ${add_target_args_LIBRARY_TYPE}
        "DEPENDS_ON"
        "DEPENDS_ON_INTERFACE"
      )
    endif()

    if(add_target_args_MODULE_INTERFACE)
      library_type_error(
        ${add_target_args_TARGET}
        ${add_target_args_LIBRARY_TYPE}
        "MODULE_INTERFACE"
        "HEADER_INTERFACE"
      )
    endif()
  endif()

  if(add_target_args_LIBRARY_TYPE STREQUAL "OBJECT")
    if(add_target_args_HEADER_INTERFACE)
      library_type_error(
        ${add_target_args_TARGET}
        ${add_target_args_LIBRARY_TYPE}
        "HEADER_INTERFACE"
        "HEADERS"
      )
    endif()

    if(add_target_args_MODULE_INTERFACE)
      library_type_error(
        ${add_target_args_TARGET}
        ${add_target_args_LIBRARY_TYPE}
        "MODULE_INTERFACE"
        "SOURCES"
      )
    endif()

    if(add_target_args_DEPENDS_ON_INTERFACE)
      library_type_error(
        ${add_target_args_TARGET}
        ${add_target_args_LIBRARY_TYPE}
        "DEPENDS_ON_INTERFACE"
        "DEPENDS_ON"
      )
    endif()

    if(add_target_args_INSTALL_WITH)
      library_type_error(
        ${add_target_args_TARGET}
        ${add_target_args_LIBRARY_TYPE}
        "INSTALL_WITH"
        ""
      )
    endif()
  endif()

  # Parameters that aren't supported by multiple library types go here
  if(add_target_args_LINK_OPTIONS)
    set(unsupported_library_types HEADER_ONLY OBJECT)
    list(FIND unsupported_library_types ${add_target_args_LIBRARY_TYPE} has_unsupported_library_type)
    if(NOT has_unsupported_library_type EQUAL -1)
      library_type_error(
        ${add_target_args_TARGET}
        ${add_target_args_LIBRARY_TYPE}
        "LINK_OPTIONS"
        ""
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
      MODULE_INTERFACE
      HEADER_INTERFACE
      DEPENDS_ON_INTERFACE
  )
  ADD_TARGETS_EXTRACT_ARGS("${flags}" "${single_value_args}" "${list_args}" "${ARGN}")
  if(NOT add_target_args_SOURCES AND NOT add_target_args_HEADER_INTERFACE AND NOT add_target_args_MODULE_INTERFACE)
    message(FATAL_ERROR "build rule '${CMAKE_CURRENT_FUNCTION}' requires at least one of 'SOURCES <file>...', 'HEADER_INTERFACE <file>...', or 'MODULE_INTERFACE <file>...' as a parameter")
  endif()

  check_library_type(
    TARGET           ${add_target_args_TARGET}
    LIBRARY_TYPE     ${add_target_args_LIBRARY_TYPE}
    SOURCES          ${add_target_args_SOURCES}
    HEADERS          ${add_target_args_HEADERS}
    HEADER_INTERFACE ${add_target_args_HEADER_INTERFACE}
  )

  if(add_target_args_INSTALL_WITH AND NOT add_target_args_INSTALL_PERMISSIONS)
    set(
      add_target_args_INSTALL_PERMISSIONS
        OWNER_READ
        OWNER_WRITE
        GROUP_READ
        WORLD_READ
    )
  endif()

  if(${add_target_args_LIBRARY_TYPE} STREQUAL "HEADER_ONLY")
    add_library(${add_target_args_TARGET} INTERFACE)
    target_include_directories(${add_target_args_TARGET} INTERFACE)
    add_scoped_options(
      SCOPE                  "INTERFACE"
      TARGET                 "${add_target_args_TARGET}"
      HEADERS                "${add_target_args_HEADER_INTERFACE}"
      DEPENDS_ON             "${add_target_args_DEPENDS_ON_INTERFACE}"
      DEFINE                 "" # deliberately empty
      COMPILE_OPTIONS        "" # deliberately empty
      LINK_OPTIONS           "" # deliberately empty
      INSTALL_WITH           "${add_target_args_INSTALL_WITH}"
      INSTALL_PREFIX_INCLUDE "${add_target_args_INSTALL_PREFIX_INCLUDE}"
      INSTALL_PREFIX_LIBRARY "${add_target_args_INSTALL_PREFIX_LIBRARY}"
      INSTALL_PERMISSIONS    "${add_target_args_INSTALL_PERMISSIONS}"
    )
  else()
    add_library(
      ${add_target_args_TARGET}
      ${add_target_args_LIBRARY_TYPE}
      "${add_target_args_SOURCES}"
    )
    add_scoped_options(
      SCOPE                  "PUBLIC"
      TARGET                 "${add_target_args_TARGET}"
      HEADERS                "${add_target_args_HEADER_INTERFACE}"
      DEPENDS_ON             "${add_target_args_DEPENDS_ON_INTERFACE}"
      DEFINE                 "" # deliberately empty
      COMPILE_OPTIONS        "" # deliberately empty
      LINK_OPTIONS           "" # deliberately empty
      INSTALL_WITH           "${add_target_args_INSTALL_WITH}"
      INSTALL_PREFIX_INCLUDE "${add_target_args_INSTALL_PREFIX_INCLUDE}"
      INSTALL_PREFIX_LIBRARY "${add_target_args_INSTALL_PREFIX_LIBRARY}"
      INSTALL_PERMISSIONS    "${add_target_args_INSTALL_PERMISSIONS}"
    )
    add_scoped_options(
      SCOPE                  "PRIVATE"
      TARGET                 "${add_target_args_TARGET}"
      HEADERS                "${add_target_args_HEADERS}"
      DEPENDS_ON             "${add_target_args_DEPENDS_ON}"
      DEFINE                 "${add_target_args_DEFINE}"
      COMPILE_OPTIONS        "${add_target_args_COMPILE_OPTIONS}"
      LINK_OPTIONS           "${add_target_args_LINK_OPTIONS}"
      INSTALL_WITH           "" # deliberately empty
      INSTALL_PREFIX_INCLUDE "" # deliberately empty
      INSTALL_PREFIX_LIBRARY "" # deliberately empty
      INSTALL_PERMISSIONS    "" # deliberately empty
    )

    if(add_target_args_MODULE_INTERFACE)
      target_sources(
        ${add_target_args_TARGET}
        PUBLIC
        FILE_SET CXX_MODULES
        FILES "${add_target_args_MODULE_INTERFACE}"
      )
    endif()
  endif()
endfunction()

function(cxx_test)
  cxx_executable_impl("${ARGN}")
  ADD_TARGETS_EXTRACT_ARGS("" "" "" ${ARGN})
  if(add_target_args_INSTALL_WITH)
    message(SEND_ERROR "cxx_test '${add_target_args_TARGET}' specifies 'INSTALL_WITH', but tests can't be installed")
  endif()
  add_test(test.${add_target_args_TARGET} ${add_target_args_TARGET})
endfunction()
