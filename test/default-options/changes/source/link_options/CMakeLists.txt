cxx_library(
  TARGET greeter_link_options
  LIBRARY_TYPE SHARED
  HEADER_INTERFACE
    greeter.hpp
  SOURCES
    greeter.cpp
  LINK_OPTIONS
    -z nodlopen
)
cxx_test(
  TARGET test_greeter_link_options
  HEADERS
    greeter.hpp
  SOURCES
    test_greeter.cpp
  DEPENDS_ON
    greeter_link_options
  LINK_OPTIONS
    -pie
)
cxx_executable(
  TARGET hello_link_options
  HEADERS
    greeter.hpp
  SOURCES
    hello.cpp
  DEPENDS_ON
    greeter_link_options
  LINK_OPTIONS
    -pie
)
