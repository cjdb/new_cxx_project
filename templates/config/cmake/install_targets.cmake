include(CMakePackageConfigHelpers)

# Here's an example installation target that you can potentially use as-is. We leave it commented
# out until you have something to install; CMake produces a fatal error when the installation target
# doesn't have anything to install.
#
# install(
#   EXPORT ${project_name}-installation-target
#   FILE ${project_name}-config.cmake
#   NAMESPACE ${project_name}::
#   DESTINATION lib/cmake/${project_name}
#   CXX_MODULES_DIRECTORY lib/modules/${project_name}
# )

message(
  AUTHOR_WARNING "no installation targets have been declared (please modify $${CMAKE_CURRENT_SOURCE_DIR}/config/cmake/install_targets.cmake to rectify this)"
)
