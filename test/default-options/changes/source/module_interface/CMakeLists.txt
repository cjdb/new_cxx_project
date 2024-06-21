cxx_library(
  TARGET greeter_module
  LIBRARY_TYPE STATIC
  MODULE_INTERFACE
    greeter_module.cpp
  SOURCES
    greeter.cpp
)
