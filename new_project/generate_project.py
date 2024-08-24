# Copyright Christopher Di Bella
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See /LICENCE for licence information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
from datetime import datetime
from git import Repo, Submodule
from new_project.generate_cmake import generate_cmake
from pathlib import Path
import new_project.diagnostics as diagnostics
import new_project.import_templates as import_templates
import os
import re
import shutil
import sys


def generate(path: Path, author: str, remote: str, package_manager: str,
             package_manager_remote: str):
    if not os.path.isabs(path):
        path = path.absolute()

    project_name = path.name.replace('-', '_')

    # FIXME: learn how to support UTF-8 and support valid UTF-8 project names too.
    if not re.match('^[A-Za-z][A-Za-z_0-9]*$', project_name):
        diagnostics.report_error(
            f''''{project_name}' cannot be used as a project name because it is not a valid C++ identifier''',
            fatal=True)

    if Path.exists(path):
        diagnostics.report_error(
            f"""'{path}' already exists, aborting to avoid overwriting its contents...""",
            fatal=True,
        )

    generate_cmake(project_name=project_name,
                   path=path,
                   package_manager=package_manager)
    generate_docs(project_name=project_name,
                  author=author,
                  path=path,
                  package_manager=package_manager)

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
    shutil.copytree(f'{import_templates.template_dir}/.vscode',
                    f'{path}/.vscode')

    generate_repo(project_name=project_name,
                  path=path,
                  remote=remote,
                  package_manager=package_manager,
                  package_manager_remote=package_manager_remote)


def generate_docs(project_name: str, author: str, path: Path,
                  package_manager: str):
    os.makedirs(f'{path}/docs/source/project', exist_ok=True)

    import_templates.substitute(
        template='README.md',
        prefix=path,
        replace={
            'author': author,
            'year': datetime.now().year,
            'project_name': project_name,
            'build_systems': 'source/project/cmake',
            'package_managers': '\nsource/project/vcpkg',
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
            'build_systems': f'{indent}source/project/cmake.rst',
            'package_managers': f'{indent}source/project/vcpkg.rst',
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

    if package_manager == 'vcpkg':
        import_templates.substitute(
            template='docs/source/project/vcpkg.rst',
            prefix=path,
            replace={
                'project_name': project_name,
            },
        )

    docs = f'{path}/docs'
    shutil.copytree(f'{import_templates.template_dir}/docs/_templates',
                    f'{docs}/_templates')
    shutil.copy(f'{import_templates.template_dir}/docs/requirements.in',
                f'{docs}/requirements.in')
    shutil.copy(f'{import_templates.template_dir}/docs/requirements.txt',
                f'{docs}/requirements.txt')
    os.symlink(f'../README.md', f'{docs}/index.md')
    os.symlink(f'../LICENCE', f'{docs}/LICENCE.md')
    os.symlink(f'../CODE_OF_CONDUCT.md', f'{docs}/CODE_OF_CONDUCT.md')


def generate_repo(project_name: str, path: Path, remote: str,
                  package_manager: str, package_manager_remote: str):
    repo = Repo.init(path=path, mkdir=False)
    repo.active_branch.rename('main')

    if remote:
        repo.create_remote(name='origin', url=f'{remote}')
        if 'github.com' in remote:
            try_generate_github(project_name=project_name,
                                remote=remote,
                                path=path)

    shutil.copy(f'{import_templates.template_dir}/.gitignore',
                f'{path}/.gitignore')

    if package_manager == 'vcpkg':
        if not package_manager_remote:
            package_manager_remote = 'https://github.com/Microsoft/vcpkg.git'
        vcpkg = Submodule.add(
            repo=repo, name="vcpkg", path=f"{path}/vcpkg", url=package_manager_remote
        )
        vcpkg.update(recursive=True, init=True, to_latest_revision=True)

    add = os.listdir(path)
    add.remove(".git")
    add.remove("vcpkg")
    repo.index.add(add)
    repo.index.commit(
        'initial commit\n\nThis commit was generated using https://github.com/cjdb/new_cxx_project.'
    )


def try_generate_github(project_name: str, remote: str, path: Path):
    if '://github.com/' in remote:
        remote_matcher = re.compile(
            r'^((git|https)://)?github.com/(.*/.*[.]git)$')
    else:
        remote_matcher = re.compile('^((git)@github.com):(.*/.*[.]git)$')

    repository = remote_matcher.match(remote)
    if not repository:
        diagnostics.report_error(
            f"remote '{remote}' contains 'github.com', but it looks incorrect")
        diagnostics.report_note("valid remotes include:\n"
                                "  * 'https://github.com/user/repo.git'\n"
                                "  * 'git://github.com/user/repo.git'\n"
                                "  * 'git@github.com:user/repo.git'")
        sys.exit(1)  # FIXME: raise an exception

    os.makedirs(f'{path}/.github/workflows')
    shutil.copytree(f'{import_templates.template_dir}/.github/ISSUE_TEMPLATE',
                    f'{path}/.github/ISSUE_TEMPLATE')

    import_templates.substitute(
        template='.github/pull_request_template.md',
        prefix=path,
        replace={},
    )
    import_templates.substitute(
        template='.github/workflows/basic_ci.yml',
        prefix=path,
        replace={
            'PROJECT_NAME': project_name.upper(),
            'repository': repository.group(3)
        },
    )
