cxx_library(
  TARGET header_only
  LIBRARY_TYPE HEADER_ONLY
  HEADER_INTERFACE hello.hpp
  DEPENDS_ON something
)
