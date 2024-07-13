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
        '-std',
        choices=[
            'c++11',
            'c++14',
            'c++17',
            'c++20',
            'c++23',
            'gnu++11',
            'gnu++14',
            'gnu++17',
            'gnu++20',
            'gnu++23',
        ],
        default='gnu++23',
        help='The C++ standard to build against (default=gnu++23).',
    )
    parser.add_argument(
        '--remote',
        type=str,
        help='A remote that the repo can be uploaded to by default',
        default='')

    return parser.parse_args()
