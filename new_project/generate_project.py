# Copyright (c) Christopher Di Bella.
# SPDX-License-Identifier: Apache-2.0 with LLVM Exception
#
import os
from pathlib import Path
from enum import Enum
import re
import string
import shutil
import new_project.import_templates as import_templates
import new_project.diagnostics as diagnostics


def generate(path: Path, author: str, std: str):
    project_name = path.name.replace('-', '_')

    # FIXME: learn how to support UTF-8 and support valid UTF-8 project names too.
    if re.search('[^A-Za-z_0-9]', project_name):
        diagnostics.report_error(
            f''''{project_name}' cannot be used as a project name because it is not a valid C++ identifier''',
            fatal=True)

    generate_cmake(project_name=project_name,
                   path=path,
                   std=std[-2:],
                   extensions_enabled=std[0] == 'g')
    generate_docs(project_name=project_name, path=path)

    import_templates.substitute(
        template='README.md',
        prefix=path,
        replace={
            'project_name': project_name,
        },
    )
    import_templates.substitute(
        template='CODE_OF_CONDUCT.md',
        prefix=path,
        replace={
            'project_name': project_name,
            'remote': 'GitHub',
        },
    )
    import_templates.substitute(
        template='LICENCE',
        prefix=path,
        replace={
            'project_name': project_name,
        },
    )
    import_templates.substitute(
        template='.clang-format',
        prefix=path,
        replace={},
    )
    import_templates.substitute(
        template='.clang-tidy',
        prefix=path,
        replace={
            'PROJECT_NAME': project_name.upper(),
        },
    )
    import_templates.substitute(
        template='.clangd',
        prefix=path,
        replace={},
    )

    os.makedirs(f'{path}/source', exist_ok=True)
    shutil.copy(f'{import_templates.template_dir}/source/CMakeLists.txt',
                f'{path}/source/CMakeLists.txt')


def generate_cmake(project_name: str, path: Path, std: int,
                   extensions_enabled: bool):
    os.makedirs(f'{path}/config/cmake/detail', exist_ok=True)
    import_templates.substitute(
        template='config/cmake/detail/default_options.cmake',
        prefix=path,
        replace={
            'PROJECT_NAME': project_name.upper(),
        },
    )
    import_templates.substitute(
        template='config/cmake/install_targets.cmake',
        prefix=path,
        replace={
            'project_name': project_name,
        },
    )
    import_templates.substitute(
        template='config/cmake/project_options.cmake',
        prefix=path,
        replace={},
    )

    import_templates.substitute(
        template='CMakeLists.txt',
        prefix=path,
        replace={
            'cxx_standard': std,
            'extensions': 'Yes' if extensions_enabled else 'No',
            'PROJECT_NAME': project_name.upper(),
        },
    )

    generate_toolchain(Toolchain.GNU, path, '/usr')
    generate_toolchain(Toolchain.LLVM, path, '/usr')


Toolchain = Enum('Toolchain', ['GNU', 'LLVM'])


def generate_toolchain(toolchain: Toolchain, path: Path, prefix: Path):
    os.makedirs(f'{path}/config/cmake/toolchains', exist_ok=True)
    indent = f'\n    '
    if toolchain == Toolchain.LLVM:
        cc = 'clang'
        cxx = 'clang++'
        ar = 'llvm-ar'
        rc = 'llvm-rc'
        ranlib = 'llvm-ranlib'
        linker = 'LLD'
        stdlib = f'{indent}-stdlib=libc++'
        hardening = f'{indent}-D_LIBCPP_HARDENING_MODE=_LIBCPP_HARDENING_MODE_FAST'
        compiler_rt = f'{indent}-rtlib=compiler-rt'
        libunwind = f'{indent}-unwindlib=libunwind'
        suffix = '-llvm'
    else:
        cc = 'gcc'
        cxx = 'g++'
        ar = 'ar'
        rc = 'rc'
        ranlib = 'ranlib'
        linker = 'GOLD'
        stdlib = ''
        hardening = f'{indent}-D_GLIBCXX_ASSERTIONS'
        compiler_rt = ''
        libunwind = ''
        suffix = '-gnu'

    triple = 'x86_64-unknown-linux-gnu'
    target = triple.partition('-')[0]
    system_name = 'Linux'
    import_templates.substitute(
        template='config/cmake/toolchains/toolchain_base.cmake',
        prefix=path,
        rename=f'{triple.replace('-gnu', suffix)}.cmake',
        replace={
            'stdlib': stdlib,
            'hardening': hardening,
            'compiler_rt': compiler_rt,
            'libunwind': libunwind,
            'cc': cc,
            'cxx': cxx,
            'ar': ar,
            'rc': rc,
            'ranlib': ranlib,
            'linker': linker,
            'system_name': system_name,
            'target': target,
            'triple': triple,
            'prefix': prefix,
        },
    )


def generate_docs(project_name: str, path: Path):
    os.makedirs(f'{path}/docs', exist_ok=True)

    import_templates.substitute(
        template='docs/CMakeLists.txt',
        prefix=path,
        replace={
            'PROJECT_NAME': project_name.upper(),
        },
    )
