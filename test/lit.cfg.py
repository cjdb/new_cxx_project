# Copyright (c) LLVM Foundation
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
import lit.formats
import lit.util
import os
import platform
import re
import subprocess
import sys
import tempfile
from pathlib import Path

from lit.llvm import llvm_config
from lit.llvm.subst import ToolSubst, FindTool

config.name = 'new-c++-project'
config.test_format = lit.formats.ShTest(not llvm_config.use_lit_shell)
config.suffixes = ['.test']
config.excludes = []
config.test_source_root = os.path.dirname(__file__)
config.test_exec_root = os.path.join(config.clang_obj_root, 'test')
homedir = tempfile.TemporaryDirectory()
config.environment['HOME'] = homedir.name

llvm_config.use_default_substitutions()
llvm_config.use_clang()

config.substitutions.append(('%PATH%', config.environment['PATH']))

config.substitutions.append(
    ('%new-project',
     f'{Path(__file__).resolve().parent.resolve().parent}/new_cxx_project.py'))
config.substitutions.append(('%expect-error', 'exit $(($? == 0))'))

tool_dirs = []
tools = []
