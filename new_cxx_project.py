#!/usr/bin/env python3
# Copyright (c) Christopher Di Bella.
# SPDX-License-Identifier: Apache-2.0 with LLVM Exception
#
import sys
from pathlib import Path
from args import parse_args
from new_project.generate_project import generate
import new_project.diagnostics as diagnostics


def main():
    args = parse_args()
    generate(path=Path(args.path),
             author=args.author,
             std=args.std,
             remote=args.remote)
    sys.exit(int(diagnostics.total_errors != 0))


if __name__ == "__main__":
    main()
