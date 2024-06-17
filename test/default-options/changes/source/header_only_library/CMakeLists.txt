cxx_library(
  TARGET greeter_header_only
  LIBRARY_TYPE HEADER_ONLY
  HEADER_INTERFACE
    greeter.hpp
)

cxx_executable(
  TARGET hello_header_only
  SOURCES
    hello.cpp
  LINK_TARGETS
    greeter_header_only
)

cxx_test(
  TARGET test_greeter_header_only
  SOURCES
    test_greeter.cpp
  LINK_TARGETS
    greeter_header_only
)
