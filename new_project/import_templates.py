# Copyright (c) Christopher Di Bella.
# SPDX-License-Identifier: Apache-2.0 with LLVM Exception
#
import os
import re
from pathlib import Path
from string import Template
from typing import Dict

template_dir = f'{Path(__file__).resolve().parent}/../templates'


def substitute(replace: Dict[str, str],
               template: str,
               prefix: str,
               rename: str = None) -> str:
    with open(f'{template_dir}/{template}') as f:
        data = Template(f.read())

    suffix = template if not rename else os.path.join(
        os.path.dirname(template), rename)
    path = f'{prefix}/{suffix}'
    with open(path, 'w') as f:
        f.write(re.sub(r'^\s+$', '', data.substitute(replace)))
    return path
