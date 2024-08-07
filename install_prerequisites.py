#!/usr/bin/env python3
import os
from pathlib import Path
import platform
import subprocess
import sys
import venv


class PackageManager:
    def __init__(self):
        config = f"{os.path.expanduser('~')}/.config"
        if not Path(config).exists():
            os.makedirs(config)
        self.venv_path = f"{config}/new_cxx_project"
        self.pip = f"{self.venv_path}/bin/pip"

    def install_python_packages(self):
        venv.create(
            self.venv_path,
            system_site_packages=True,
            clear=True,
            symlinks=True,
            with_pip=True,
            upgrade_deps=True,
        )

        subprocess.run(
            [
                self.pip,
                "install",
                "-r",
                f"{Path(__file__).resolve().parent}/docs/requirements.txt",
            ]
        ).check_returncode()

        print(
            f"\033[1m\033[91mYou will need to add '{self.venv_path}/bin' to your PATH before running new_cxx_project.py\033[0m",
            file=sys.stderr,
        )

    def install_prerequisites(self):
        self.install_python_packages()
        print(
            "No supported package managers were detected, only the Python packages were installed. Please manually install the following packages:\n"
            "git\n"
            "curl\n"
            "cmake\n"
            "libz3\n"
            "ninja\n"
            "pkgconf\n"
            "tar\n"
            "unzip\n"
            "zip\n",
            file=sys.stderr,
        )


class Apt(PackageManager):
    def install_prerequisites(self):
        subprocess.run(
            [
                "apt-get",
                "install",
                "build-essential",
                "git",
                "curl",
                "cmake",
                "libz3-dev",
                "ninja-build",
                "pkg-config",
                "tar",
                "unzip",
                "zip",
            ]
        ).check_returncode()

        self.install_python_packages()


class Pacman(PackageManager):
    def install_prerequisites(self):
        subprocess.run(
            [
                "pacman",
                "-S",
                "base-devel",
                "cmake",
                "curl",
                "git",
                "ninja",
                "pkgconf",
                "zip",
                "unzip",
            ]
        ).check_returncode()

        self.install_python_packages()


class DNF(PackageManager):
    def install_prerequisites(self):
        subprocess.run(
            [
                "dnf",
                "install",
                "make",
                "automake",
                "gcc",
                "gcc-c++",
                "git",
                "kernel-devel",
                "cmake",
                "curl",
                "ninja-build",
                "pkgconf",
                "tar",
                "unzip",
                "zip",
            ]
        ).check_returncode()

        self.install_python_packages()


class ZYpp(PackageManager):
    def install_prerequisites(self):
        subprocess.run(
            [
                "zypper",
                "install",
                "cmake",
                "curl",
                "gcc-c++",
                "git",
                "ninja",
                "patterns-devel-base-devel_basis",
                "pkgconf",
                "tar",
                "unzip",
                "zip",
            ]
        ).check_returncode()

        self.install_python_packages()


class Brew(PackageManager):
    def install_prerequisites(self):
        subprocess.run(
            [
                "brew",
                "install",
                "cmake",
                "curlpp",
                "ninja",
                "unzip",
                "zip",
            ]
        ).check_returncode()

        self.install_python_packages()


class UnsupportedPlatform(Exception):
    def __init__(self, platform):
        super().__init__(f"the platform '{platform}' isn't supported by {sys.argv[0]}")


def detect_platform():
    system = platform.system()
    if not system in ["Linux", "Darwin"]:
        raise UnsupportedPlatform(system)

    if system == "Darwin":
        return Brew()

    try:
        release_info = platform.freedesktop_os_release()
    except Exception as e:
        raise

    if "ID_LIKE" in release_info:
        id = release_info["ID_LIKE"]
        if id == "debian":
            return Apt()

        if "suse" in id:
            return ZYpp()

    if "ID" in release_info:
        id = release_info["ID"]

        if id == "arch":
            return Pacman()
        if id == "fedora":
            return DNF()

    return PackageManager()


def main():
    if sys.version_info < (3, 10):
        print(
            f"python version is {sys.version_info.major}.{sys.version_info.minor}; install_prerequisites.py needs at least 3.10",
            file=sys.stderr,
        )
        sys.exit(1)

    try:
        detect_platform().install_prerequisites()
    except Exception as e:
        print(e, file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
