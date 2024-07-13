set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_C_COMPILER "/usr/bin/clang")
set(CMAKE_C_COMPILER_AR "/usr/bin/llvm-ar")
set(CMAKE_C_COMPILER_RANLIB "/usr/bin/llvm-ranlib")
set(CMAKE_C_COMPILER_TARGET x86_64-unknown-linux-gnu)

set(CMAKE_CXX_COMPILER "/usr/bin/clang++")
set(CMAKE_CXX_COMPILER_AR "/usr/bin/llvm-ar")
set(CMAKE_CXX_COMPILER_RANLIB "/usr/bin/llvm-ranlib")
set(CMAKE_CXX_COMPILER_TARGET x86_64-unknown-linux-gnu)

set(CMAKE_RC_COMPILER "/usr/bin/llvm-rc")
set(CMAKE_RC_COMPILER_AR "/usr/bin/llvm-ar")
set(CMAKE_RC_COMPILER_RANLIB "/usr/bin/llvm-ranlib")

set(CMAKE_LINKER_TYPE LLD)

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
    -stdlib=libc++
    -D_LIBCPP_HARDENING_MODE=_LIBCPP_HARDENING_MODE_FAST
)
string(
  JOIN " " CMAKE_EXE_LINKER_FLAGS_INIT
    -rtlib=compiler-rt
    -unwindlib=libunwind
)

string(
  JOIN " " CMAKE_CXX_FLAGS_DEBUG_INIT
    -fsanitize=address,undefined -fno-sanitize-recover=all
)
string(
  JOIN " " CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT
    -fsanitize=address,undefined -fno-sanitize-recover=all
)

string(
  JOIN " " CMAKE_CXX_FLAGS_RELEASE_INIT
    -flto=thin
    -fsanitize=undefined -fno-sanitize-recover=all -fsanitize-minimal-runtime
)
string(
  JOIN " " CMAKE_EXE_LINKER_FLAGS_RELEASE_INIT
    -flto=thin
    -fsanitize=undefined -fno-sanitize-recover=all -fsanitize-minimal-runtime
)

string(
  JOIN " " CMAKE_CXX_FLAGS_MINSIZEREL_INIT
    -flto=thin
    -fsanitize=undefined -fno-sanitize-recover=all -fsanitize-minimal-runtime
)
string(
  JOIN " " CMAKE_EXE_LINKER_FLAGS_MINSIZEREL_INIT
    -flto=thin
    -fsanitize=undefined -fno-sanitize-recover=all -fsanitize-minimal-runtime
)

string(
  JOIN " " CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT
    -fsanitize=address,undefined -fno-sanitize-recover=all
)
string(
  JOIN " " CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_INIT
    -fsanitize=address,undefined -fno-sanitize-recover=all
)
