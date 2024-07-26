# Copyright VORtech <https://www.vortech.nl/en/integrating-sphinx-in-cmake>
# Copyright Christopher Di Bella
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See /LICENCE for licence information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
include(FindPackageHandleStandardArgs)
include(GNUInstallDirs)

if(NOT ${PROJECT_NAME}_BUILD_DOCS)
  return()
endif()

find_package(Python3 COMPONENTS Interpreter REQUIRED)

if(Python3_FOUND)
  get_filename_component(_PYTHON_DIR "$${Python3_EXECUTABLE}" DIRECTORY)
  set(
    _Python3_PATHS
    "$${_Python3_DIR}"
    "$${_Python3_DIR}/bin"
    "$${_Python3_DIR}/Scripts"
  )
endif()

find_program(
  SPHINX_EXECUTABLE
  NAMES sphinx-build sphinx-build.exe
  HINTS "$${_Python3_PATHS}"
)
mark_as_advanced(SPHINX_EXECUTABLE)

find_package_handle_standard_args(Sphinx DEFAULT_MSG SPHINX_EXECUTABLE)

if(NOT Sphinx_FOUND)
  return()
endif()

set(_SPHINX_SCRIPT_DIR "$${CMAKE_CURRENT_LIST_DIR}")

if(NOT EXISTS "$${PROJECT_SOURCE_DIR}/docs/_static")
  file(MAKE_DIRECTORY "$${PROJECT_SOURCE_DIR}/docs/_static")
endif()

function(sphinx_documentation TARGET_NAME)
  cmake_parse_arguments(
    sphinx_args
    ""
    "TARGET;CONF_FILE"
    "SOURCES;TEMPLATES;STATIC"
    $${ARGN}
  )

  set(SPHINX_DEPENDS "$${sphinx_args_CONF_FILE}" "$${sphinx_args_SOURCES}" "$${sphinx_args_TEMPLATES}" "$${sphinx_args_STATIC}")

  add_custom_command(
    OUTPUT "$${CMAKE_CURRENT_BINARY_DIR}/html.stamp"
    COMMAND "$${SPHINX_EXECUTABLE}" -q -j auto -b html "$${CMAKE_CURRENT_LIST_DIR}" "$${CMAKE_CURRENT_BINARY_DIR}"
    COMMAND "$${CMAKE_COMMAND}" -E touch "$${CMAKE_CURRENT_BINARY_DIR}/html.stamp"
    DEPENDS "$${SPHINX_DEPENDS}"
  )
  set(TARGET_DEPENDS "$${CMAKE_CURRENT_BINARY_DIR}/html.stamp")

  add_custom_target(
    $${TARGET_NAME} ALL
    DEPENDS $${TARGET_DEPENDS}
  )

  install(
    DIRECTORY "$${CMAKE_CURRENT_BINARY_DIR}/"
    TYPE DOC
    PATTERN ".buildinfo"  EXCLUDE
    PATTERN ".doctrees"   EXCLUDE
    PATTERN "_sources"    EXCLUDE
    PATTERN "objects.inv" EXCLUDE
    PATTERN "CMakeFiles"  EXCLUDE
    PATTERN "html.stamp"  EXCLUDE
    REGEX   ".*[.]cmake$$" EXCLUDE
  )
endfunction()
