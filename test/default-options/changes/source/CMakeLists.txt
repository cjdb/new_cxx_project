cxx_library(
  TARGET greeter
  LIBRARY_TYPE OBJECT
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

cxx_library(
  TARGET greeter_header_only
  LIBRARY_TYPE HEADER_ONLY
  HEADER_INTERFACE greeter_lib.hpp
)
cxx_test(
  TARGET hello_consumes_header_only
  SOURCES hello_consumes_header_only.cpp
  LINK_TARGETS greeter_header_only
)

cxx_library(
  TARGET greeter_static
  LIBRARY_TYPE STATIC
  HEADER_INTERFACE greeter.hpp
  SOURCES greeter.cpp
)
cxx_test(
  TARGET hello_consumes_static
  SOURCES hello.cpp
  LINK_TARGETS greeter_static
)

cxx_library(
  TARGET greeter_shared
  LIBRARY_TYPE SHARED
  HEADER_INTERFACE greeter.hpp
  SOURCES greeter.cpp
)
cxx_test(
  TARGET hello_consumes_shared
  SOURCES hello.cpp
  LINK_TARGETS greeter_shared
)
