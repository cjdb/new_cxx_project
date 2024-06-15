cxx_library(
  TARGET greeter
  LIBRARY_TYPE OBJECT
  HEADER_INTERFACE "greeter.hpp"
  SOURCES greeter.cpp
  DEFINE
    A_LIBRARY_MACRO
    ANOTHER_LIBRARY_MACRO=648
)
cxx_test(
  TARGET test_greeter
  SOURCES test_greeter.cpp
  LINK_TARGETS greeter
  DEFINE
    A_TEST_MACRO
    ANOTHER_TEST_MACRO=42
)
cxx_executable(
  TARGET hello
  SOURCES hello.cpp
  LINK_TARGETS greeter
  DEFINE
    AN_EXE_MACRO
    ANOTHER_EXE_MACRO=56
)

cxx_executable(
  TARGET hello_standalone
  SOURCES
    hello.cpp
    greeter.cpp
  DEFINE
    A_LIBRARY_MACRO
    ANOTHER_LIBRARY_MACRO=648
    AN_EXE_MACRO
    ANOTHER_EXE_MACRO=56
)
cxx_test(
  TARGET test_greeter_standalone
  SOURCES
    test_greeter.cpp
    greeter.cpp
  DEFINE
    A_LIBRARY_MACRO
    ANOTHER_LIBRARY_MACRO=648
    A_TEST_MACRO
    ANOTHER_TEST_MACRO=42
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
  DEFINE
    A_LIBRARY_MACRO
    ANOTHER_LIBRARY_MACRO=648
)
cxx_test(
  TARGET hello_consumes_static
  SOURCES hello.cpp
  LINK_TARGETS greeter_static
  DEFINE
    AN_EXE_MACRO
    ANOTHER_EXE_MACRO=56
)

cxx_library(
  TARGET greeter_shared
  LIBRARY_TYPE SHARED
  HEADER_INTERFACE greeter.hpp
  SOURCES greeter.cpp
  DEFINE
    A_LIBRARY_MACRO
    ANOTHER_LIBRARY_MACRO=648
)
cxx_test(
  TARGET hello_consumes_shared
  SOURCES hello.cpp
  LINK_TARGETS greeter_shared
  DEFINE
    AN_EXE_MACRO
    ANOTHER_EXE_MACRO=56
)
