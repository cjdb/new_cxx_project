FROM ubuntu:noble

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository universe
RUN apt-get update
RUN apt-get install -y wget lsb-release
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-get remove -y '*clang*' '*llvm*'
RUN apt-get autoremove -y
RUN apt-get install -y \
  build-essential      \
  bzip2                \
  curl                 \
  gcc-14               \
  g++-14               \
  libssl-dev           \
  libz3-dev            \
  ninja-build          \
  pkg-config           \
  python-is-python3    \
  python3              \
  python3-git          \
  python3-myst-parser  \
  python3-pip          \
  python3-psutil       \
  python3-sphinx       \
  tar                  \
  unzip                \
  wget                 \
  zip
ENV LLVM_VERSION=19
RUN apt-add-repository "deb http://apt.llvm.org/noble/ llvm-toolchain-noble main"
RUN apt-get update
RUN apt-get install -y                \
  libllvm${LLVM_VERSION}              \
  llvm-${LLVM_VERSION}                \
  llvm-${LLVM_VERSION}-dev            \
  llvm-${LLVM_VERSION}-runtime        \
  clang-${LLVM_VERSION}               \
  clang-tools-${LLVM_VERSION}         \
  libclang-common-${LLVM_VERSION}-dev \
  libclang-${LLVM_VERSION}-dev        \
  libclang1-${LLVM_VERSION}           \
  clang-format-${LLVM_VERSION}        \
  python3-clang-${LLVM_VERSION}       \
  clang-tidy-${LLVM_VERSION}          \
  libclang-rt-${LLVM_VERSION}-dev     \
  libfuzzer-${LLVM_VERSION}-dev       \
  lld-${LLVM_VERSION}                 \
  libc++-${LLVM_VERSION}-dev          \
  libc++abi-${LLVM_VERSION}-dev       \
  libunwind-${LLVM_VERSION}-dev       \
  libllvmlibc-${LLVM_VERSION}-dev
RUN git clone https://github.com/Kitware/CMake.git --depth=1        && \
    cd CMake                                                        && \
    ./bootstrap --parallel=$(nproc) --generator=Ninja --no-debugger && \
    ninja                                                           && \
    ninja install                                                   && \
    cd ..                                                           && \
    rm -rf CMake
WORKDIR /
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/llvm-rc llvm-rc /usr/bin/llvm-rc-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/llvm-ranlib llvm-ranlib /usr/bin/llvm-ranlib-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/FileCheck FileCheck /usr/bin/FileCheck-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/lit lit /usr/lib/llvm-${LLVM_VERSION}/build/utils/lit/lit.py 100
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 100
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 100
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-14 100
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-14 100
