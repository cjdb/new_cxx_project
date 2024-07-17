if(NOT ${PROJECT_NAME}_BUILD_DOCS)
  return()
endif()

sphinx_documentation(
  TARGET docs
  CONF_FILE "conf.py"
  SOURCES
    "index.md"
    "LICENCE.md"
    "CODE_OF_CONDUCT.md"${build_systems}${package_managers}
  TEMPLATES
    "_templates/layout.html"
)
