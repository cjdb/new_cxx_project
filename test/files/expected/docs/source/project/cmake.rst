..
  Copyright (c) 2024 Christopher Di Bella
  Licensed under Creative Commons Attribution-ShareAlike 4.0 International
  See /LICENCE for licence information.
  SPDX-License-Identifier: CC BY-SA 4.0

***********
Using CMake
***********

copied_okay has a robust set of configuration options and a library that allows for faster C++
development. This page documents how everything fits together.

Config options
==============

Default config options
----------------------

:code:`new-c++-project.py` provides the following config options for all C++ projects.

.. option:: COPIED_OKAY_BUILD_DOCS

  :Type: :code:`BOOL`
  :Default: :code:`Yes`

  Toggles whether the documentation is built. Requires `Sphinx <https://www.sphinx-doc.org>`_ and
  `MyST <https://myst-parser.readthedocs.io>`_ to be installed.

Project-specific config options
-------------------------------

Project-specific config options should be added to :code:`config/cmake/handle_options.cmake`, and
documented here.

Packages
========

Project-specific package dependencies should be added to :code:`config/cmake/add_packages.cmake`, and
documented here.

Toolchain files
===============

copied_okay has two toolchain files to :code:`config/cmake/toolchain`. Both toolchains enable a
variety of warnings, security mechanisms, and optimisations (release-only).

**LLVM toolchain**

:Path: :code:`config/cmake/toolchain/x86_64-unknown-linux-gnu-clang-with-llvm-toolchain.cmake`
:Compiler: Clang
:Linker: lld
:Standard library: libc++
:Compiler runtime: compiler-rt
:Unwind library: libunwind

**GNU toolchain**

:Path: :code:`config/cmake/toolchain/x86_64-unknown-linux-gnu-gcc.cmake`
:Compiler: GCC
:Linker: gold
:Standard library: libstdc++
:Compiler runtime: libgcc
:Unwind library: libgcc_eh

Creating binaries
=================

To ensure that simple binaries are built with as few CMake errors as possible, this project provides
a set of rules that can build executables, libraries, and tests. The primary advantage of using these
rules over the default CMake rules is that they handle some desirable defaults for everything, and
also bundle all of your rules into a single rule (as opposed to needing to repeat yourself, a la
:code:`add_executable(target sources...)`, :code:`add_compile_options(target options...)`,
:code:`add_compile_definitions(target definitions...)`, etc., which can be error-prone).

All rules **must** be provided with a :code:`TARGET` (the name of the binary to be built), and at
least one source file needs to be listed using either the :code:`SOURCES` named parameter,
the :code:`HEADER_INTERFACE` named parameter (:func:`cxx_library` only), or the
:code:`MODULE_INTERFACE` named parameter (:func:`cxx_library` only).

.. code-block:: cmake

  # A standalone executable.
  cxx_executable(
    TARGET hello
    SOURCES hello.cpp
  )

  # A greeter using conventional C++ headers.
  cxx_library(
    TARGET greeter
    LIBRARY_TYPE OBJECT
    SOURCES greeter.cpp
    HEADER_INTERFACE greeter.hpp
  )

  cxx_test(
    TARGET test_greeter
    SOURCES test_greeter.cpp
    DEPENDS_ON greeter
  )

  # A header-only version.
  cxx_library(
    TARGET greeter_header_only
    LIBRARY_TYPE HEADER_ONLY
    HEADER_INTERFACE greeter_header_only.hpp
  )

  cxx_test(
    TARGET test_greeter_header_only
    SOURCES test_greeter.cpp
    DEPENDS_ON greeter_header_only
  )

  # A greeter using C++20 modules.
  cxx_library(
    TARGET module_based_greeter
    MODULE_INTERFACE module_based_greeter.cpp
  )

  cxx_test(
    TARGET test_module_based_greeter
    SOURCES test_module_based_greeter.cpp
    DEPENDS_ON module_based_greeter
  )

.. function::
  cxx_executable(\
    TARGET target_name \
    SOURCES source_files...\
    COMPILE_OPTIONS options...\
    DEFINE macros...\
    HEADERS headers...\
    INDCLUDE directories...\
    LINK_OPTIONS linker_options...\
    DEPENDS_ON dependencies... \
    INSTALL_WITH install_target \
    INSTALL_PERMISSIONS install_permissions...)

  Builds an executable program. Accepts the following parameters:

  .. option:: TARGET:STRING

    The name of the executable.

  .. option:: SOURCES:LIST[STRING]

    Paths to each source file.

    .. code-block:: cmake

        cxx_executable(
          TARGET hello
          SOURCES
            hello.cpp
            greeter.cpp
        )

  .. option:: COMPILE_OPTIONS:LIST[STRING]

    Provides the compiler with a set of options that are only be applicable to the current target.

    .. code-block:: cmake

        cxx_executable(
          TARGET hello
          SOURCES hello.cpp
          COMPILE_OPTIONS
            -Wno-float-conversion
            -Wno-literal-conversion
        )

  .. option:: DEFINE:LIST[STRING]

    Tells the compiler to define these macros for every source file.

    .. code-block:: cmake

        cxx_executable(
          TARGET hello
          SOURCES hello.cpp
          DEFINE
            COPIED_OKAY_USE_ASAN
            COPIED_OKAY_RETURN_VALUE=1
        )

  .. option:: HEADERS:LIST[STRING]

    Tells the compiler the set of headers that the target depends on.

    .. code-block:: cmake

      cxx_executable(
        TARGET hello
        SOURCES hello.cpp
        HEADERS
          "${PROJECT_SOURCE_DIR}/include/greeting.hpp"
      )

  .. option:: LINK_OPTIONS:LIST[STRING]

    Provides the linker with a set of options that are only be applicable to the current target.

    .. code-block:: cmake

        cxx_executable(
          TARGET hello
          SOURCES hello.cpp
          LINK_OPTIONS
            -fuse-ld=mold
        )

  .. option:: DEPENDS_ON:LIST[STRING]

    Tells CMake which targets this one depends on.

    .. code-block:: cmake

        cxx_executable(
          TARGET hello_triangle
          SOURCES hello_triangle.cpp
          DEPENDS_ON
            Vulkan
            GLFW3
        )

  .. option:: INSTALL_WITH:STRING

    Installs the executable to :code:`${CMAKE_INSTALL_PREFIX}/bin` when :code:`install_target` is
    invoked as a build target.

  .. option:: INSTALL_PERMISSIONS:LIST[STRING]

    Determines the permissions that the executable will have when installed. Valid values include
    :code:`OWNER_READ`, :code:`OWNER_WRITE`, :code:`OWNER_EXECUTE`, :code:`GROUP_READ`,
    :code:`GROUP_WRITE`, :code:`GROUP_EXECUTE`, :code:`WORLD_READ`, :code:`WORLD_WRITE`, and
    :code:`WORLD_EXECUTE`.

    Defaults to :code:`OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE`.

.. function::
  cxx_library(\
    TARGET target_name\
    LIBRARY_TYPE library_type\
    SOURCES sources...\
    MODULE_INTERFACE export_module_sources...\
    HEADERS headers\
    HEADER_INTERFACE headers_to_export\
    DEFINE macros...\
    DEPENDS_ON_INTERFACE public_dependencies...\
    DEPENDS_ON private_dependencies... \
    INSTALL_WITH install_target \
    INSTALL_PREFIX_INCLUDE directory \
    INSTALL_PREFIX_LIBRARY directory \
    INSTALL_PERMISSIONS install_permissions...)

  Builds a library. :func:`cxx_library` supports the following named arguments.

  .. option:: TARGET:STRING

    The name of the library.

  .. option::
    SOURCES:LIST[STRING]
    MODULE_INTERFACE:LIST[STRING]

    Both are used to indicate which source files are built for this target. :code:`MODULE_INTERFACE`
    refers to any file containing :code:`export module`.

    .. code-block:: cmake

      cxx_library(
        TARGET greeter
        MODULE_INTERFACE greeter.cpp
        SOURCES strings.cpp
      )

  .. option:: LIBRARY_TYPE:STRING

    Determines how the library should be produced. Valid values include:

      * :code:`STATIC` builds the target as a static library. Static libraries are typically shipped
        as a deliverable for other projects to consume.

        .. code-block:: cmake
          :caption: The executable :code:`hello` will have all of :code:`greeter`'s code linked at
                    build time. The project does not need to ship :code:`greeter` for :code:`hello`
                    to be usable.

          cxx_library(
            TARGET greeter
            LIBRARY_TYPE STATIC
            HEADER_INTERFACE
              "${PROJECT_SOURCE_DIR}/include/greeter.hpp"
              "${PROJECT_SOURCE_DIR}/include/strings.hpp"
            SOURCES
              greeter.cpp
              strings.cpp
          )

          cxx_binary(
            TARGET hello
            DEPENDS_ON greeter
          )

      * :code:`SHARED` builds the target as a shared library. Shared libraries are typically shipped
        as a deliverable for other projects to consume.

        .. code-block:: cmake
          :caption: The executable :code:`hello` will not contain any of :code:`greeter`'s code, and
                    requires the project to ship :code:`greeter` in order for :code:`hello` to be
                    usable.

          cxx_library(
            TARGET greeter
            LIBRARY_TYPE SHARED
            HEADER_INTERFACE
              "${PROJECT_SOURCE_DIR}/include/greeter.hpp"
              "${PROJECT_SOURCE_DIR}/include/strings.hpp"
            SOURCES
              greeter.cpp
              strings.cpp
          )

          cxx_binary(
            TARGET hello
            DEPENDS_ON greeter
          )

      * :code:`PLUGIN` builds the target as a shared object that *must* be loaded at runtime, and
        cannot be linked using the compiler or linker.

        .. code-block:: cmake

          cxx_library(
            TARGET greeter
            LIBRARY_TYPE PLUGIN
            SOURCES
              greeter.cpp
              strings.cpp
          )

          # Error: attempting to link greeter
          cxx_binary(
            TARGET hello
            DEPENDS_ON greeter
          )

        .. note::

          The official CMake term for this is :code:`MODULE`. We use :code:`PLUGIN` to avoid
          confusion with C++20 modules.

      * :code:`OBJECT` builds the target as an intermediary object file. Object files are project-local
        targets that are used to modularise a build. Unlike all other library types, object files
        cannot be exported by the project.

        .. code-block:: cmake

          cxx_library(
            TARGET greeter
            LIBRARY_TYPE OBJECT
            HEADER_INTERFACE
              "${PROJECT_SOURCE_DIR}/include/greeter.hpp"
              "${PROJECT_SOURCE_DIR}/include/strings.hpp"
            SOURCES
              greeter.cpp
              strings.cpp
          )

          cxx_binary(
            TARGET hello
            DEPENDS_ON greeter
          )

      * :code:`HEADER_ONLY` builds the target as a header-only library. Since header-only libraries
        only consist of headers, it isn't possible to use :code:`SOURCES`, :code:`MODULE_INTERFACE`,
        or :code:`HEADERS`.

        .. code-block:: cmake

          cxx_library(
              TARGET greeter
              LIBRARY_TYPE HEADER_ONLY
              HEADER_INTERFACE
                strings.hpp
                greeter.hpp
            )

            cxx_binary(
              TARGET hello
              DEPENDS_ON greeter
            )

  .. option::
    HEADERS:LIST[STRING]
    HEADER_INTERFACE:LIST[STRING]

    Tells the build system the set of headers that the target depends on. Headers listed under
    :code:`HEADER_INTERFACE` are installed, while headers listed under :code:`HEADERS` are not.

    .. code-block:: cmake

      cxx_library(
        TARGET hello
        LIBRARY_TYPE OBJECT
        HEADER_INTERFACE
          "${PROJECT_SOURCE_DIR}/include/greeter.hpp"
        HEADERS
          "${PROJECT_SOURCE_DIR}/source/strings.hpp"
        SOURCES
          greeter.cpp
          strings.cpp
      )

  .. option:: DEFINE:LIST[STRING]

    As above, but for macros.

  .. option::
    DEPENDS_ON_INTERFACE:LIST[STRING]
    DEPENDS_ON:LIST[STRING]

    Tells CMake which targets this one depends on. :code:`DEPENDS_ON_INTERFACE` dependencies are
    propagated; dependencies listed under :code:`DEPENDS_ON` are not.

    .. code-block:: cmake

        cxx_executable(
          TARGET hello_triangle
          SOURCES hello_triangle.cpp
          DEPENDS_ON
            Vulkan
            GLFW3
        )

  .. option:: INSTALL_WITH:STRING

    Installs header interfaces to :code:`${CMAKE_INSTALL_PREFIX}/include`, and static archives,
    shared objects, and plugins to :code:`${CMAKE_INSTALL_PREFIX}/lib` when :code:`install_target`
    is invoked as a build target.

    .. note::

      Module interfaces can't be installed at the moment.

  .. option:: INSTALL_PREFIX_INCLUDE:STRING

    Tells the build system to install headers to the path in
    :code:`${CMAKE_INSTALL_PREFIX}/include/${INSTALL_PREFIX_INCLUDE}`.

  .. option:: INSTALL_PREFIX_LIBRARY:STRING

    Tells the build system to install static archives, shared objects, and plugins to the path in
    :code:`${CMAKE_INSTALL_PREFIX}/include/${INSTALL_PREFIX_LIBRARY}`.

  .. option:: INSTALL_PERMISSIONS:LIST[STRING]

    Determines the permissions that the library will have when installed. Valid values include
    :code:`OWNER_READ`, :code:`OWNER_WRITE`, :code:`OWNER_EXECUTE`, :code:`GROUP_READ`,
    :code:`GROUP_WRITE`, :code:`GROUP_EXECUTE`, :code:`WORLD_READ`, :code:`WORLD_WRITE`, and
    :code:`WORLD_EXECUTE`.

    Defaults to :code:`OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ`.

.. function:: cxx_test

  A wrapper around :func:`cxx_executable` to register the executable with CTest. The parameters are
  identical, excluding install options.

  The test will be named :code:`test.$TARGET_NAME`, where :code:`$TARGET_NAME` is a placeholder for
  what you passed to :code:`TARGET`.
