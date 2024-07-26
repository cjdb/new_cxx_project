cxx_library(
  TARGET greeter_static
  LIBRARY_TYPE STATIC
  HEADER_INTERFACE
    greeter.hpp
  SOURCES
    greeter.cpp
  INSTALL_WITH install-targets
  INSTALL_PREFIX_INCLUDE static-inc
  INSTALL_PREFIX_LIBRARY static
)
cxx_library(
  TARGET fanciful_static
  LIBRARY_TYPE STATIC
  HEADER_INTERFACE
    fanciful.hpp
  SOURCES
    fanciful.cpp
  DEPENDS_ON_INTERFACE
    greeter_static
)
cxx_test(
  TARGET test_greeter_static
  SOURCES
    test_greeter.cpp
  DEPENDS_ON
    check
    fanciful_static
)
cxx_executable(
  TARGET hello_static
  SOURCES
    hello.cpp
  DEPENDS_ON
    fanciful_static
  INSTALL_WITH install-target
  INSTALL_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_EXECUTE WORLD_READ
)
