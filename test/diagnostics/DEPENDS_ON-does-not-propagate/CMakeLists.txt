cxx_library(
  TARGET make_fancy
  LIBRARY_TYPE SHARED
  HEADER_INTERFACE
    make_fancy.hpp
  SOURCES
    make_fancy.cpp
  DEPENDS_ON
    -s
)
cxx_library(
  TARGET greeting
  LIBRARY_TYPE STATIC
  HEADER_INTERFACE
    greeter.hpp
  SOURCES
    greeter.cpp
  DEPENDS_ON
    make_fancy
)
cxx_executable(
  TARGET hello
  SOURCES
    hello.cpp
  DEPENDS_ON
    greeting
)
