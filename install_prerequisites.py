#!/usr/bin/env python3
import os
import platform
import subprocess
import sys
import venv


class PackageManager:
    def __init__(self):
        self.venv_path = f"{os.path.expanduser('~')}/.new_cxx_project"
        self.pip = f"{self.venv_path}/bin/pip"

    def pip_fallback(self, prefix):
        print(
            f"{prefix}, will use python-pip as a fallback. Creating a virtual environment in '{self.venv_path}', and will install as many packages as possible there using Pip. You will need to add '{self.venv_path}/bin' to your PATH before running new_cxx_project.py.",
            file=sys.stderr,
        )

        venv.create(
            self.venv_path,
            system_site_packages=True,
            clear=True,
            symlinks=True,
            with_pip=True,
            upgrade_deps=True,
        )

        subprocess.run(
            [self.pip, "install", "GitPython", "myst-parser", "psutil", "sphinx"]
        ).check_returncode()

        print(
            f"\033[1m\033[91mYou will need to add '{self.venv_path}/bin' to your PATH before running new_cxx_project.py\033[0m",
            file=sys.stderr,
        )

    def install_prerequisites(self):
        self.pip_fallback("No supported package managers were detected")
        subprocess.run(
            [self.pip, "install", "cmake", "libcurl", "ninja"]
        ).check_returncode()
        print(
            f"\033[1m\033[91mYou will need to add '{self.venv_path}/bin' to your PATH before running new_cxx_project.py\033[0m",
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
                "python3-git",
                "python3-myst-parser",
                "python3-psutil",
                "python3-sphinx",
                "tar",
                "unzip",
                "zip",
            ]
        ).check_returncode()


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
                "python-gitpython",
                "python-myst-parser",
                "python-psutil",
                "python-sphinx",
                "zip",
                "unzip",
            ]
        ).check_returncode()


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
                "kernel-devel",
                "cmake",
                "curl",
                "ninja-build",
                "pkgconf",
                "python3-GitPython",
                "python3-myst-parser",
                "python3-psutil",
                "python3-sphinx",
                "tar",
                "unzip",
                "zip",
            ]
        ).check_returncode()


class ZYpp(PackageManager):
    def __init__(self, distro):
        self.distro = distro

    def install_prerequisites(self):
        print(self.distro)
        subprocess.run(
            [
                "zypper",
                "install",
                "cmake",
                "curl",
                "gcc-c++",
                "ninja",
                "patterns-devel-base-devel_basis",
                "pkgconf",
                "python311-GitPython",
                "python3-myst-parser",
                "python3-psutil",
                "python3-Sphinx",
                "tar",
                "unzip",
                "zip",
            ]
        ).check_returncode()


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

        self.pip_fallback("Homebrew doesn't manage Python packages")


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
            return ZYpp(release_info["ID"])

    if "ID" in release_info:
        id = release_info["ID"]

        if id == "arch":
            return Pacman()
        if id == "fedora":
            return DNF()

    return PackageManager()


def main():
    if sys.version_info < (3, 11):
        print(
            f"python version is {sys.version_info.major}.{sys.version_info.minor}; needs at least 3.11",
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
