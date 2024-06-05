set(CMAKE_SYSTEM_NAME ${system_name})
set(CMAKE_SYSTEM_PROCESSOR ${target})

set(CMAKE_C_COMPILER "${prefix}/bin/${cc}")
set(CMAKE_C_COMPILER_AR "${prefix}/bin/${ar}")
set(CMAKE_C_COMPILER_RANLIB "${prefix}/bin/${ranlib}")
set(CMAKE_C_COMPILER_TARGET ${triple})

set(CMAKE_CXX_COMPILER "${prefix}/bin/${cxx}")
set(CMAKE_CXX_COMPILER_AR "${prefix}/bin/${ar}")
set(CMAKE_CXX_COMPILER_RANLIB "${prefix}/bin/${ranlib}")
set(CMAKE_CXX_COMPILER_TARGET ${triple})

set(CMAKE_RC_COMPILER "${prefix}/bin/${rc}")
set(CMAKE_RC_COMPILER_AR "${prefix}/bin/${ar}")
set(CMAKE_RC_COMPILER_RANLIB "${prefix}/bin/${ranlib}")

set(CMAKE_LINKER_TYPE ${linker})

string(
  JOIN " " CMAKE_CXX_FLAGS_INIT
    -fdiagnostics-color=always
    -fstack-protector-strong
    -fvisibility=hidden
    -Werror
    -pedantic
    -Wall
    -Wattributes
    -Wcast-align
    -Wconversion
    -Wdouble-promotion
    -Wextra
    -Wformat=2
    -Wnon-virtual-dtor
    -Wnull-dereference
    -Wodr
    -Wold-style-cast
    -Woverloaded-virtual
    -Wshadow
    -Wsign-conversion
    -Wsign-promo
    -Wunused
    -Wno-ignored-attributes
    -Wno-cxx-attribute-extension
    -Wno-gnu-include-next
    -Wno-private-header
    -Wno-unused-command-line-argument${stdlib}${hardening}
)

string(
  JOIN " " CMAKE_EXE_LINKER_FLAGS_INIT${compiler_rt}${libunwind}
)
