cxx_library(
  TARGET greeter_shared
  LIBRARY_TYPE SHARED
  HEADER_INTERFACE
    greeter.hpp
  SOURCES
    greeter.cpp
)
cxx_library(
  TARGET fanciful_shared
  LIBRARY_TYPE SHARED
  HEADER_INTERFACE
    fanciful.hpp
  SOURCES
    fanciful.cpp
  DEPENDS_ON_INTERFACE
    greeter_shared
)
cxx_test(
  TARGET test_greeter_shared
  SOURCES
    test_greeter.cpp
  DEPENDS_ON
    check
    fanciful_shared
)
cxx_executable(
  TARGET hello_shared
  SOURCES
    hello.cpp
  DEPENDS_ON
    fanciful_shared
)
