cxx_library(
  TARGET object
  LIBRARY_TYPE OBJECT
  SOURCES hello.cpp
  DEPENDS_ON_INTERFACE greeter
)
