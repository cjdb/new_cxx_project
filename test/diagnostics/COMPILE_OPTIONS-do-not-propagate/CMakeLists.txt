cxx_library(
  TARGET greeting
  LIBRARY_TYPE STATIC
  HEADER_INTERFACE
    greeter.hpp
  SOURCES
    greeter.cpp
  COMPILE_OPTIONS
    -DRETURN_TYPE
)
cxx_executable(
  TARGET hello
  SOURCES
    hello.cpp
  LINK_TARGETS
    greeting
)
