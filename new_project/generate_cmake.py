from enum import Enum
import os
from pathlib import Path
import new_project.import_templates as import_templates


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
        template='config/cmake/detail/add_targets.cmake',
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
