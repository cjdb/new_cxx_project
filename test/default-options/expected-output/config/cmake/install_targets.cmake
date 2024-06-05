include(CMakePackageConfigHelpers)

# Here's an example installation target that you can potentially use as-is. We leave it commented
# out until you have something to install; CMake produces a fatal error when the installation target
# doesn't have anything to install.
#
# install(
#   EXPORT default_options-installation-target
#   FILE default_options-config.cmake
#   NAMESPACE default_options::
#   DESTINATION lib/cmake/default_options
#   CXX_MODULES_DIRECTORY lib/modules/default_options
# )

message(
  AUTHOR_WARNING "no installation targets have been declared (please modify ${CMAKE_CURRENT_SOURCE_DIR}/config/cmake/install_targets.cmake to rectify this)"
)
