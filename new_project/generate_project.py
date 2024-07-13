# Copyright (c) Christopher Di Bella.
# SPDX-License-Identifier: Apache-2.0 with LLVM Exception
#
from git import Repo
from new_project.generate_cmake import generate_cmake
from pathlib import Path
import new_project.diagnostics as diagnostics
import new_project.import_templates as import_templates
import os
import re
import shutil


def generate(path: Path, author: str, remote: str):
    project_name = path.name.replace('-', '_')

    # FIXME: learn how to support UTF-8 and support valid UTF-8 project names too.
    if not re.match('^[A-Za-z][A-Za-z_0-9]*$', project_name):
        diagnostics.report_error(
            f''''{project_name}' cannot be used as a project name because it is not a valid C++ identifier''',
            fatal=True)

    if Path.exists(path):
        diagnostics.report_error(
            f''''{path}' already exists, aborting to avoid overwriting its contents...'''
        )

    generate_cmake(project_name=project_name, path=path)
    generate_docs(project_name=project_name, author=author, path=path)

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

    generate_repo(path, remote)


def generate_docs(project_name: str, author: str, path: Path):
    os.makedirs(f'{path}/docs/source/project', exist_ok=True)

    import_templates.substitute(
        template='README.md',
        prefix=path,
        replace={
            'project_name': project_name,
            'build_systems': 'source/project/cmake'
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

    indent = '\n    '
    import_templates.substitute(
        template='docs/CMakeLists.txt',
        prefix=path,
        replace={
            'PROJECT_NAME': project_name.upper(),
            'build_systems': f'{indent}source/project/cmake.rst'
        },
    )
    import_templates.substitute(
        template='docs/conf.py',
        prefix=path,
        replace={
            'project_name': project_name,
            'author': author,
        },
    )
    import_templates.substitute(
        template='docs/source/project/cmake.rst',
        prefix=path,
        replace={
            'project_name': project_name,
            'PROJECT_NAME': project_name.upper(),
        },
    )

    docs = f'{path}/docs'
    shutil.copytree(f'{import_templates.template_dir}/docs/_templates',
                    f'{docs}/_templates')
    os.symlink(f'../README.md', f'{docs}/index.md')
    os.symlink(f'../LICENCE', f'{docs}/LICENCE.md')
    os.symlink(f'../CODE_OF_CONDUCT.md', f'{docs}/CODE_OF_CONDUCT.md')


def generate_repo(path: Path, remote: str):
    repo = Repo.init(path=path, mkdir=False)
    repo.active_branch.rename('main')

    if remote:
        repo.create_remote(name='origin', url=f'{remote}')
    shutil.copy(f'{import_templates.template_dir}/.gitignore',
                f'{path}/.gitignore')
    repo.index.add(
        ['*', '.gitignore', '.clang-format', '.clang-tidy', '.clangd'])
    repo.index.commit(
        'initial commit\n\nThis commit was generated using https://github.com/cjdb/new_cxx_project.'
    )
