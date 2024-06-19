cxx_library(
  TARGET greeter
  LIBRARY_TYPE OBJECT
  HEADERS
    greeter.hpp
  SOURCES
    greeter.cpp
  COMPILE_OPTIONS
    -fPIC
)
cxx_library(
  TARGET greeter_impl
  LIBRARY_TYPE OBJECT
  HEADERS
    greeter.hpp
  SOURCES
    greeter_impl.cpp
  COMPILE_OPTIONS
    -fPIC
)
cxx_library(
  TARGET greeting
  LIBRARY_TYPE SHARED
  HEADER_INTERFACE
    greeter.hpp
  COMPILE_OPTIONS
    -fPIC
  LINK_TARGETS
    greeter
    greeter_impl
  LINK_OPTIONS
    --no-demangle
)
cxx_executable(
  TARGET hello
  SOURCES
    hello.cpp
  LINK_TARGETS
    greeting
)
