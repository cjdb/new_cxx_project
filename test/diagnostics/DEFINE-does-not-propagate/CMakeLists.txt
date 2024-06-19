cxx_library(
  TARGET greeting
  LIBRARY_TYPE STATIC
  HEADER_INTERFACE
    greeter.hpp
  SOURCES
    greeter.cpp
  DEFINE
    RETURN_TYPE
)
cxx_executable(
  TARGET hello
  SOURCES
    hello.cpp
  DEPENDS_ON
    greeting
)
