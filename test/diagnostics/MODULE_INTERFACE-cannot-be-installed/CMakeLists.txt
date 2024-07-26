cxx_library(
  TARGET module_interface_tries_to_install
  LIBRARY_TYPE STATIC
  MODULE_INTERFACE hello.cpp
  INSTALL_WITH a
)
