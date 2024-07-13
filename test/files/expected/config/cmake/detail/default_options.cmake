# This file was autogenerated by new-c++-project.py. Do not modify this file, as add_targets.cmake
# heavily depends on it.

function(validate_option value option valid_values)
  list(FIND "${valid_values}" "${value}" found)

  if(found EQUAL -1)
    message(FATAL_ERROR "invalid value '${value}' for ${option} (valid values are [${${valid_values}}])")
  endif()
endfunction()

if (NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_CONFIGURATION_TYPES Debug RelWithDebInfo MinSizeRel Release)
endif()

if(CMAKE_BUILD_TYPE)
  list(FIND CMAKE_CONFIGURATION_TYPES "${CMAKE_BUILD_TYPE}" valid_build_type)
  if(valid_build_type EQUAL -1)
    message(FATAL_ERROR "${CMAKE_BUILD_TYPE} is not a valid value")
  endif()
else()
  message(FATAL_ERROR "CMAKE_BUILD_TYPE must be set")
endif()
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

set(
  # Variable
  COPIED_OKAY_BUILD_DOCS
  # Default value
  Yes
  CACHE STRING
  "Toggles whether the documentation is built. Requires both Sphinx and MyST to be installed first."
)
