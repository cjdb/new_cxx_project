#!/usr/bin/env python3
import shutil
import sys


def main():
    for i in sys.argv[1:]:
        shutil.rmtree(i, True)


if __name__ == "__main__":
    main()
