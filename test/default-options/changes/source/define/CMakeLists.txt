cxx_library(
  TARGET greeter_with_macro
  LIBRARY_TYPE STATIC
  HEADER_INTERFACE
    greeter.hpp
  SOURCES
    greeter.cpp
  DEFINE
    RETURN_TYPE
    PARAMETER_TYPE=std::string_view
)
cxx_test(
  TARGET test_greeter_with_macro
  SOURCES
    test_greeter.cpp
  DEPENDS_ON
    greeter_with_macro
  DEFINE
    RETURN_TYPE
    PARAMETER_TYPE=std::string_view
)
cxx_executable(
  TARGET hello_with_macro
  SOURCES
    hello.cpp
  DEPENDS_ON
    greeter_with_macro
  DEFINE
    RETURN_TYPE
    PARAMETER_TYPE=std::string_view
)
