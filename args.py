import argparse
import sys


def parse_args():
    parser = argparse.ArgumentParser(prog=sys.argv[0],
                                     description='Generates a new C++ project')
    parser.add_argument(
        'path',
        help='A path to the project directory. Created if absent.',
    )
    parser.add_argument(
        '--author',
        required=True,
        help='The entity who owns the copyright.',
    )
    parser.add_argument(
        '--remote',
        type=str,
        help='A remote that the repo can be uploaded to by default',
        default='')
    parser.add_argument(
        '--package-manager',
        type=str,
        choices=['none', 'vcpkg'],
        help='Specifies the package manager to use',
        default='none',
    )
    parser.add_argument(
        '--package-manager-remote',
        type=str,
        help='A remote that the package manager can be acquired from',
        default='',
    )

    return parser.parse_args()
