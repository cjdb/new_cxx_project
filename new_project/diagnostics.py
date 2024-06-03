# Copyright (c) Christopher Di Bella.
# SPDX-License-Identifier: Apache-2.0 with LLVM Exception
#
import sys
import pygments

total_errors = 0


def report_error(message: str, fatal: bool = False):
    print(f'error: {message}', file=sys.stderr)
    if fatal:
        sys.exit(1)
    ++total_errors


def report_note(message: str):
    print(f'note: {message}')
