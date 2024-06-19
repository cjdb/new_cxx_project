cxx_library(
  TARGET greeter_compile_options
  LIBRARY_TYPE STATIC
  HEADER_INTERFACE
    greeter.hpp
  SOURCES
    greeter.cpp
  COMPILE_OPTIONS
    -fno-inline
)
cxx_test(
  TARGET test_greeter_compile_options
  HEADERS
    greeter.hpp
  SOURCES
    test_greeter.cpp
  LINK_TARGETS
    greeter_compile_options
  COMPILE_OPTIONS
    -fno-inline
)
cxx_executable(
  TARGET hello_compile_options
  HEADERS
    greeter.hpp
  SOURCES
    hello.cpp
  LINK_TARGETS
    greeter_compile_options
  COMPILE_OPTIONS
    -fno-inline
)
