set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_C_COMPILER "/usr/bin/gcc")
set(CMAKE_C_COMPILER_AR "/usr/bin/ar")
set(CMAKE_C_COMPILER_RANLIB "/usr/bin/ranlib")
set(CMAKE_C_COMPILER_TARGET x86_64-unknown-linux-gnu)

set(CMAKE_CXX_COMPILER "/usr/bin/g++")
set(CMAKE_CXX_COMPILER_AR "/usr/bin/ar")
set(CMAKE_CXX_COMPILER_RANLIB "/usr/bin/ranlib")
set(CMAKE_CXX_COMPILER_TARGET x86_64-unknown-linux-gnu)

set(CMAKE_RC_COMPILER "/usr/bin/rc")
set(CMAKE_RC_COMPILER_AR "/usr/bin/ar")
set(CMAKE_RC_COMPILER_RANLIB "/usr/bin/ranlib")

set(CMAKE_LINKER_TYPE GOLD)

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
    -Wno-unused-command-line-argument
    -D_GLIBCXX_ASSERTIONS
)
string(
  JOIN " " CMAKE_EXE_LINKER_FLAGS_INIT
)

string(
  JOIN " " CMAKE_CXX_FLAGS_DEBUG_INIT
    -fsanitize=address
)
string(
  JOIN " " CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT
    -fsanitize=address
)

string(
  JOIN " " CMAKE_CXX_FLAGS_RELEASE_INIT
    -flto=auto
)
string(
  JOIN " " CMAKE_EXE_LINKER_FLAGS_RELEASE_INIT
    -flto=auto
)

string(
  JOIN " " CMAKE_CXX_FLAGS_MINSIZEREL_INIT
    -flto=auto
)
string(
  JOIN " " CMAKE_EXE_LINKER_FLAGS_MINSIZEREL_INIT
    -flto=auto
)

string(
  JOIN " " CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT
    -fsanitize=address
)
string(
  JOIN " " CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_INIT
    -fsanitize=address
)
