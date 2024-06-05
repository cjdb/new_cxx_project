cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

project("${PROJECT_NAME}" C CXX)

set(CMAKE_CXX_STANDARD ${cxx_standard})
set(CMAKE_CXX_EXTENSIONS ${extensions})
set(CMAKE_CXX_STANDARD_REQUIRED Yes)
set(CMAKE_EXPORT_COMPILE_COMMANDS Yes)

if(CMAKE_CXX_EXTENSIONS)
  message(STATUS "Building with C++$${CMAKE_CXX_STANDARD} (extensions enabled)")
else()
  message(STATUS "Building with C++$${CMAKE_CXX_STANDARD} (extensions disabled)")
endif()

include("$${PROJECT_SOURCE_DIR}/config/cmake/project_options.cmake")
enable_testing()
include(CTest)

add_subdirectory(source)

# This file is deliberately included after everything else, since installation targets depend on at
# least one target requesting to be installed first.
include("$${PROJECT_SOURCE_DIR}/config/cmake/install_targets.cmake")
