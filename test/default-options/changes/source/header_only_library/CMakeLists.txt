cxx_library(
  TARGET greeter_header_only
  LIBRARY_TYPE HEADER_ONLY
  HEADER_INTERFACE
    greeter.hpp
  INSTALL_WITH install-targets
  INSTALL_PREFIX_INCLUDE header_only
)

cxx_library(
  TARGET fanciful_header_only
  LIBRARY_TYPE HEADER_ONLY
  HEADER_INTERFACE
    fanciful.hpp
  DEPENDS_ON_INTERFACE
    greeter_header_only
)

cxx_executable(
  TARGET hello_header_only
  SOURCES
    hello.cpp
  DEPENDS_ON
    fanciful_header_only
  INSTALL_WITH install-targets
)

cxx_test(
  TARGET test_greeter_header_only
  SOURCES
    test_greeter.cpp
  DEPENDS_ON
    check
    fanciful_header_only
)
