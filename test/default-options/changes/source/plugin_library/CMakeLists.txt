cxx_library(
  TARGET plugin_handler
  LIBRARY_TYPE HEADER_ONLY
  HEADER_INTERFACE
    plugin_handler.hpp
  DEPENDS_ON_INTERFACE
    check
)
cxx_library(
  TARGET greeter_plugin
  LIBRARY_TYPE PLUGIN
  HEADER_INTERFACE
    greeter.hpp
  SOURCES
    greeter.cpp
  COMPILE_OPTIONS
    -Wno-pragmas
  INSTALL_WITH install-targets
  INSTALL_PREFIX_INCLUDE plugin
)
cxx_test(
  TARGET test_greeter_with_plugin
  HEADERS
    greeter.hpp
  SOURCES
    test_greeter.cpp
  DEPENDS_ON
    plugin_handler
  COMPILE_OPTIONS
    -Wno-pragmas
)
cxx_executable(
  TARGET hello_with_plugin
  HEADERS
    greeter.hpp
  SOURCES
    hello.cpp
  DEPENDS_ON
    plugin_handler
  COMPILE_OPTIONS
    -Wno-pragmas
  INSTALL_WITH install-targets
)
