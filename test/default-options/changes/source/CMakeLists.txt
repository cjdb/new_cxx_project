cxx_library(
  TARGET greeter
  HEADER_INTERFACE "greeter.hpp"
  SOURCES greeter.cpp
)
cxx_test(
  TARGET test_greeter
  SOURCES test_greeter.cpp
  LINK_TARGETS greeter
)
cxx_executable(
  TARGET hello
  SOURCES hello.cpp
  LINK_TARGETS greeter
)

cxx_executable(
  TARGET hello_standalone
  SOURCES
    hello.cpp
    greeter.cpp
)
cxx_test(
  TARGET test_greeter_standalone
  SOURCES
    test_greeter.cpp
    greeter.cpp
)
