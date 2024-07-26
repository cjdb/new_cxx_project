cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

project("copied_okay" C CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_EXTENSIONS Yes)
set(CMAKE_CXX_STANDARD_REQUIRED Yes)
set(CMAKE_EXPORT_COMPILE_COMMANDS Yes)

message(STATUS "Building with C++${CMAKE_CXX_STANDARD} (extensions enabled)")

include("${PROJECT_SOURCE_DIR}/config/cmake/detail/vcpkg.cmake")
include("${PROJECT_SOURCE_DIR}/config/cmake/project_options.cmake")
include("${PROJECT_SOURCE_DIR}/config/cmake/detail/add_targets.cmake")
include("${PROJECT_SOURCE_DIR}/config/cmake/import_packages.cmake")
enable_testing()
include(CTest)

add_subdirectory(source)
add_subdirectory(docs)

# This file is deliberately included after everything else, since installation targets depend on at
# least one target requesting to be installed first.
include("${PROJECT_SOURCE_DIR}/config/cmake/install_targets.cmake")
