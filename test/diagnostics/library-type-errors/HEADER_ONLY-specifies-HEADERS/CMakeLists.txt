cxx_library(
  TARGET header_only_with_HEADERS
  LIBRARY_TYPE HEADER_ONLY
  HEADERS hello.hpp
  HEADER_INTERFACE world.hpp
)
