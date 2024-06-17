cxx_library(
  TARGET greeter_static
  LIBRARY_TYPE STATIC
  HEADER_INTERFACE
    greeter.hpp
  SOURCES
    greeter.cpp
)
cxx_test(
  TARGET test_greeter_static
  SOURCES
    test_greeter.cpp
  LINK_TARGETS
    greeter_static
)
cxx_executable(
  TARGET hello_static
  SOURCES
    hello.cpp
  LINK_TARGETS
    greeter_static
)
