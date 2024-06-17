cxx_library(
  TARGET greeter_shared
  LIBRARY_TYPE SHARED
  HEADER_INTERFACE
    greeter.hpp
  SOURCES
    greeter.cpp
)
cxx_test(
  TARGET test_greeter_shared
  SOURCES
    test_greeter.cpp
  LINK_TARGETS
    greeter_shared
)
cxx_executable(
  TARGET hello_shared
  SOURCES
    hello.cpp
  LINK_TARGETS
    greeter_shared
)
