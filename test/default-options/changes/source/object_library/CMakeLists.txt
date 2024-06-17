cxx_library(
  TARGET greeter_object
  LIBRARY_TYPE OBJECT
  HEADERS
    greeter.hpp
  SOURCES
    greeter.cpp
)
cxx_test(
  TARGET test_greeter_object
  HEADERS
    greeter.hpp
  SOURCES
    test_greeter.cpp
  LINK_TARGETS
    greeter_object
)
cxx_executable(
  TARGET hello_object
  HEADERS
    greeter.hpp
  SOURCES
    hello.cpp
  LINK_TARGETS
    greeter_object
)
