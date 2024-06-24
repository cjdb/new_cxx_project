cxx_library(
  TARGET greeter_multi_file1
  LIBRARY_TYPE STATIC
  HEADER_INTERFACE
    greeter.hpp
  HEADERS
    greeter_impl.hpp
  SOURCES
    greeter.cpp
    greeter_impl.cpp
)
cxx_library(
  TARGET greeter_multi_file2
  LIBRARY_TYPE STATIC
  HEADERS
    greeter.hpp
    greeter_impl.hpp
  SOURCES
    greeter.cpp
    greeter_impl.cpp
)
cxx_library(
  TARGET greeter_multi_file3
  LIBRARY_TYPE STATIC
  HEADER_INTERFACE
    greeter.hpp
    greeter_impl.hpp
  SOURCES
    greeter.cpp
    greeter_impl.cpp
)
cxx_test(
  TARGET test_greeter_multi_file
  HEADERS
    check.hpp
    greeter.hpp
    greeter_impl.hpp
  SOURCES
    test_greeter.cpp
    greeter.cpp
    greeter_impl.cpp
)
cxx_test(
  TARGET hello_multi_file
  HEADERS
    greeter.hpp
    greeter_impl.hpp
  SOURCES
    greeter.cpp
    hello.cpp
    greeter_impl.cpp
)
