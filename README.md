<!--
  Copyright (c) 2024 Christopher Di Bella
  Licensed under Creative Commons Attribution-ShareAlike 4.0 International
  See /LICENCE for licence information.
  SPDX-License-Identifier: CC BY-SA 4.0
-->
# new_cxx_project

Welcome to new_cxx_project! This is a project template generator for C++ projects. Its primary
purpose is to reduce the amount of boilerplate that you need to interact with in order to get started
with your project.

You can read a better version of the docs at https://new-cxx-project.readthedocs.io.

```{toctree}
:maxdepth: 1

LICENCE
CODE_OF_CONDUCT
source/generated_files/cmake
source/generated_files/vcpkg
```

## Generated files

new_cxx_project currently generates a project with support for the following tools:

* Git
* GitHub (optional)
* [Sphinx](https://https://www.sphinx-doc.org) (a documentation tool)
* CMake
* [vcpkg](https://vcpkg.io) (a C++ package manager, optional)

### Git

By default, the project will start with a single commit, containing all of the generated files.

### GitHub

If the project's remote either starts with `https://github.com/` or `git@github.com:`, then the
project will contain files for opening pull requests, bug reports, feature requests, and a GitHub
Action for [continuous integration](https://en.wikipedia.org/wiki/Continuous_integration).

### Sphinx

Sphinx is a documentation tool. We generate a `docs` directory that is built alongside your project.
Sphinx supports both [Markdown](https://mystmd.org) and [reStructured Text](https://docutils.sourceforge.io/rst.html).
The readme, licence, and code of conduct files are all drafted in Markdown, but your other files can
be written in reStructured Text.

### CMake

new_cxx_project largely exists to generate CMake files that you need to write (but probably don't)
want to. The CMake library that's generated is intended to simplify your development process, so that
you spend less time writing CMake, and more time working on your project.

:::{seealso}
<project:source/generated_files/cmake.rst>
:::

### vcpkg

new_cxx_project can optionally support for vcpkg. This includes adding it as a submodule, adjusting
the CMake components to support vcpkg, and the documentation.

:::{seealso}
<project:source/generated_files/vcpkg.rst>
:::

## Getting started

### Prerequisites

new_cxx_project has a few dependencies in order to be run. The best way to install these is to run
`install_prerequisites.py`, found in the top-level directory of this repo. The only prerequisite to
run that is Python 3.

You'll also need either a full LLVM toolchain or a full GNU toolchain, if you plan to use the toolchain
files that ship with the project by default.

### Generating a project

1. This project is fairly straightforward to use. Most projects can probably get away with running the
following:
  ```sh
  $ ${HOME}/.config/new_cxx_project/python new_cxx_project.py /tmp/hello_world --author='Your name'
  ```
  This generates a project called `hello_world` in `/tmp/hello_world`.
2. Create a file called `/tmp/hello_world/source/hello.cpp`:
  ```cpp
  #include <print>

  int main()
  {
    std::println("Hello, world!");
  }
  ```
3. Edit `/tmp/hello_world/source/CMakeLists.txt`:
  ```cmake
  cxx_executable(
    TARGET hello
    SOURCES hello.cpp
  )
  ```
4. Run `cd /tmp/hello_world`.
5. Run **one** of the following:
  ```sh
  # If you have the LLVM toolchain installed (Clang, libc++, and friends)
  $ cmake -GNinja -S. -Bbuild -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE="$PWD/config/cmake/toolchains/x86_64-linux-unknown-llvm.cmake"
  ```
  ```sh
  # If you have the GNU toolchain installed (GCC and friends)
  $ cmake -GNinja -S. -Bbuild -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE="$PWD/config/cmake/toolchains/x86_64-linux-unknown-gnu.cmake"
  ```
6. Now run `ninja -C build`.
7. Finally, run `build/source/hello`. You should see `Hello, world!` output to screen.
8. Congrats! That's your first project done :)

## Options

* `--remote=<value>` sets the Git remote. If the tool detects a valid GitHub remote, then it will
  also generate files for tracking issues, pull requests, and GitHub actions.
* `--package-manager=<value>` sets the project's package manager. Valid values are `none` and `vcpkg`.
  Defaults to `none`.
* `--package-manager-remote=<value>` sets the remote to download the package manager from. Remotes
  that are on-disk should be prefixed with `file://`. The default remotes are
    * **vcpkg**: https://github.com/Microsoft/vcpkg.git

## Can you also support &lt;feature&gt;?

Contributions to the project are welcome! Supporting other toolchains, CMake features, build systems,
package managers, and remotes are certainly things that I'd like to see added. Please open a [feature
request](https://github.com/cjdb/new_cxx_project/issues/new?assignees=&labels=enhancement&projects=&template=feature_request.yml&title=%3CAdd+a+descriptive+title+here%3E)
to discuss your needs.

In particular, help with supporting MSVC and delivering updates to previously-generated projects
would be appreciated.

## Can I change the licence for the files I generate?

Sorry, no. This project has multiple contributors, and to relicencing would require getting permission
from each contributor, for each licence. Also, in order to simplify the process for developers working
on different projects generated by `new_cxx_project.py` with different owners, we intend to keep the
licencing story very simple.

The generated source code and generated documentation have different (but still really permissive) licences.
Source code is licenced under [Apache Licence, Version 2.0 with LLVM Exceptions](https://llvm.org/LICENSE.txt).
The documentation is licenced under [Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/?ref=chooser-v1)
(CC BY-SA 4.0).

## Can I edit the generated files?

Yes! You can and should edit them as you see fit. Any changes that you make are owned by you.

## Indices and tables

* {ref}`genindex`
* {ref}`search`
