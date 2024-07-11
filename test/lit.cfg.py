# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
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

# Configuration file for the 'lit' test runner.

# name: the name of this test suite
config.name = 'new-c++-project'

# testFormat: The test format used to use to interpret tests.
#
# For now we require '&&' between commands, until they get globally killed and
# the test runner updated.
config.test_format = lit.formats.ShTest(not llvm_config.use_lit_shell)

# suffixes: A list of file extensions to treat as test files.
config.suffixes = ['.test']

# excludes: A list of directories to exclude from the testsuite. The 'Inputs'
# subdirectories contain auxiliary inputs for various tests in their parent
# directories.
config.excludes = []

# test_source_root: The root path where tests are located.
config.test_source_root = os.path.dirname(__file__)

# test_exec_root: The root path where tests should be run.
config.test_exec_root = os.path.join(config.clang_obj_root, 'test')

llvm_config.use_default_substitutions()
llvm_config.use_clang()

config.substitutions.append(('%PATH%', config.environment['PATH']))

homedir = tempfile.TemporaryDirectory()
config.environment['HOME'] = homedir.name

tool_dirs = []
tools = []
