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
request](https://github.com/cjdb/project_template/issues/new?assignees=&labels=&projects=&template=feature_request.md&title=)
to discuss your needs.

## Indices and tables

* {ref}`genindex`
* {ref}`search`
