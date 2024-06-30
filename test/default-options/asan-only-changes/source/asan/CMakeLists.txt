cxx_library(
  TARGET greeter_object_with_asan
  LIBRARY_TYPE OBJECT
  HEADERS
    greeter.hpp
  SOURCES
    greeter.cpp
)
cxx_test(
  TARGET test_greeter_object_with_asan
  HEADERS
    greeter.hpp
  SOURCES
    test_greeter.cpp
  DEPENDS_ON
    check
    greeter_object_with_asan
)
cxx_executable(
  TARGET hello_object_with_asan
  HEADERS
    greeter.hpp
  SOURCES
    hello.cpp
  DEPENDS_ON
    greeter_object_with_asan
)
