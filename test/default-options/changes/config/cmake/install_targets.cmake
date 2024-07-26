include(CMakePackageConfigHelpers)

# Here's an example installation target that you can potentially use as-is. We leave it commented
# out until you have something to install; CMake produces a fatal error when the installation target
# doesn't have anything to install.
#
install(
  EXPORT install-targets
  FILE project_name-config.cmake
  NAMESPACE project_name::
  DESTINATION lib/cmake/project_name
)
