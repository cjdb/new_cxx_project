cxx_library(
  TARGET greeter_plugin
  LIBRARY_TYPE PLUGIN
  HEADERS
    greeter.hpp
  SOURCES
    greeter.cpp
)
cxx_test(
  TARGET test_greeter_with_plugin
  HEADERS
    greeter.hpp
  SOURCES
    test_greeter.cpp
)
cxx_executable(
  TARGET hello_with_plugin
  HEADERS
    greeter.hpp
  SOURCES
    hello.cpp
)
