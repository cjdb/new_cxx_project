import os
from pathlib import Path
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
