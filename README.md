# new-c++-project

Welcome to new-c++-project! This is a project template generator for C++ projects. Its primary
purpose is to reduce the amount of boilerplate that you need to interact with in order to get started
with your project.

```{toctree}
:maxdepth: 1

LICENCE
CODE_OF_CONDUCT
```

## Getting started

This project is fairly straightforward to use. Most projects can probably get away with running the
following:

```sh
$ ./new_cxx_project.py /path/to/project_name --author='Your name'
```

This will generate a C++23 project using CMake, and also give you a documentation setup similar to
this project's one.

## Options

* `-std=<value>` configures the project with a specific C++ standard. Valid values include `c++11`,
  `c++14`, `c++17`, `c++20`, `c++23`, `gnu++11`, `gnu++14`, `gnu++17`, `gnu++20`, and `gnu++23`. The
  default is `gnu++23`.

## Indices and tables

* {ref}`genindex`
* {ref}`search`
