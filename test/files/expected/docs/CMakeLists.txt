if(NOT COPIED_OKAY_BUILD_DOCS)
  return()
endif()

sphinx_documentation(
  TARGET docs
  CONF_FILE "conf.py"
  SOURCES
    "index.md"
    "LICENCE.md"
    "CODE_OF_CONDUCT.md"
    source/project/cmake.rst
    source/project/vcpkg.rst
  TEMPLATES
    "_templates/layout.html"
)
