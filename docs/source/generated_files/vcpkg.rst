..
  Copyright (c) 2024 Christopher Di Bella
  Licensed under Creative Commons Attribution-ShareAlike 4.0 International
  See /LICENCE for licence information.
  SPDX-License-Identifier: CC BY-SA 4.0

***********
Using vcpkg
***********

.. note::

  This documentation is the same documentation that would be generated for your project when using
  new_cxx_project. The term :code:`${project_name}` will be replaced with your project's designated
  name.

${project_name} uses `vcpkg <https://vcpkg.io>`_ for package management. We use the
`manifest mode <https://learn.microsoft.com/en-au/vcpkg/concepts/manifest-mode>`_.

Adding packages
================

To add a dependency, add it to the top-level ``vcpkg.json``, and then add the corresponding CMake
``find_package`` (or equivalent) rule to ``config/cmake/add_packages.cmake``.

Setting up the toolchain with vcpkg
===================================

This project aims to build its dependencies with the same compile-time options as its own targets,
where possible (Titus Winters' keynote, `'C++ Past vs. Future' <https://youtu.be/IY8tHh2LSX4?si=LUdksQ8evdWYCuR7>`_,
summarises why we adopt this philosophy). ${project_name} generates a vcpkg toolchain file when you
configure the project, so you shouldn't follow the vcpkg instructions for setting things up. Instead,
just configure the project using the options documented in :doc:`cmake`. You can optionally set
:code:`-DVCPKG_INSTALL_OPTIONS`, which will be passed to vcpkg.

.. code-block::
  :caption: An example showing how vcpkg can be used. The ``-DVCPKG_INSTALL_OPTIONS='--clean-after-build'``
            option is optional, and tells vcpkg to clean its build cache after all packages are installed.

  $ cmake -S. -Bbuild -GNinja                                                                     \
      -DCMAKE_BUILD_TYPE=Debug                                                                    \
      -DTOOLCHAIN_FILE='/path/to/project/config/cmake/toolchains/x86_64-unknown-linux-llvm.cmake' \
      -DVCPKG_INSTALL_OPTIONS='--clean-after-build'                                               \
      <project options...>
