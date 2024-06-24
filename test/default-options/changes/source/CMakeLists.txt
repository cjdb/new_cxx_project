cxx_library(
  TARGET check
  LIBRARY_TYPE HEADER_ONLY
  HEADER_INTERFACE
    check.hpp
)

add_subdirectory(header_only_library)
add_subdirectory(object_library)
add_subdirectory(plugin_library)
add_subdirectory(shared_library)
add_subdirectory(static_library)
add_subdirectory(multi_file)
add_subdirectory(define)
add_subdirectory(compile_options)
add_subdirectory(link_options)
add_subdirectory(module_interface)
