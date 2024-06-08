# Copyright (c) Christopher Di Bella.
# SPDX-License-Identifier: Apache-2.0 with LLVM Exception
#
import os
from pathlib import Path
from enum import Enum
import re
import string
import shutil
from new_project.generate_cmake import generate_cmake
import new_project.import_templates as import_templates
import new_project.diagnostics as diagnostics


def generate(path: Path, author: str, std: str):
    project_name = path.name.replace('-', '_')

    # FIXME: learn how to support UTF-8 and support valid UTF-8 project names too.
    if not re.match('^[A-Za-z][A-Za-z_0-9]*$', project_name):
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


def generate_docs(project_name: str, path: Path):
    os.makedirs(f'{path}/docs', exist_ok=True)

    import_templates.substitute(
        template='docs/CMakeLists.txt',
        prefix=path,
        replace={
            'PROJECT_NAME': project_name.upper(),
        },
    )
