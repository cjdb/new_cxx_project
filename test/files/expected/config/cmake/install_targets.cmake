include(CMakePackageConfigHelpers)

# Here's an example installation target that you can potentially use as-is. We leave it commented
# out until you have something to install; CMake produces a fatal error when the installation target
# doesn't have anything to install.
#
# install(
#   EXPORT copied_okay-install
#   FILE copied_okay-config.cmake
#   NAMESPACE copied_okay::
#   DESTINATION lib/cmake/copied_okay
# )

message(
  AUTHOR_WARNING "no installation targets have been declared (please modify ${CMAKE_CURRENT_SOURCE_DIR}/config/cmake/install_targets.cmake to rectify this)"
)
