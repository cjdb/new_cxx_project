from enum import Enum
import os
from pathlib import Path
import new_project.import_templates as import_templates


def generate_cmake(project_name: str, path: Path, package_manager: str):
    os.makedirs(f'{path}/config/cmake/detail', exist_ok=True)
    os.makedirs(f'{path}/config/cmake/packages', exist_ok=True)

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
        template='config/cmake/import_packages.cmake',
        prefix=path,
        replace={},
    )
    import_templates.substitute(
        template='config/cmake/packages/FindSphinx.cmake',
        prefix=path,
        replace={
            'PROJECT_NAME': project_name.upper(),
        },
    )
    import_templates.substitute(
        template='config/cmake/detail/add_targets.cmake',
        prefix=path,
        replace={},
    )

    include_package_manager = ''
    if package_manager == 'vcpkg':
        include_package_manager = generate_vcpkg(path=path, project_name=project_name)

    import_templates.substitute(
        template='CMakeLists.txt',
        prefix=path,
        replace={
            'PROJECT_NAME': project_name.upper(),
            'include_package_manager': f'\n{include_package_manager}' if include_package_manager else '',
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
        lto=f'-flto=thin'
        cfi=f'{indent}-fsanitize=undefined -fno-sanitize-recover=all -fsanitize-minimal-runtime'
        undefined=',undefined -fno-sanitize-recover=all'

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
        lto = '-flto=auto'
        cfi = ''
        undefined = ''

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
            'lto': lto,
            'cfi': cfi,
            'undefined': undefined,
        },
    )


def generate_vcpkg(path: Path, project_name: str):
    import_templates.substitute(
        template='vcpkg.json',
        prefix=path,
        replace={
            'project_name': project_name.replace('_', '-'),
        },
    )
    import_templates.substitute(
        template='config/cmake/detail/vcpkg.cmake',
        prefix=path,
        replace={
            'PROJECT_NAME': project_name.upper(),
        },
    )
    import_templates.substitute(
        template='config/cmake/detail/vcpkg_toolchain_file.cmake.in',
        prefix=path,
        replace={
            'PROJECT_NAME': project_name.upper(),
        },
    )

    return 'include("${PROJECT_SOURCE_DIR}/config/cmake/detail/vcpkg.cmake")'
