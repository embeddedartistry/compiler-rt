# compiler-rt (meson port)

This project wraps the llvm compiler-rt repository and enables users to use it in meson-based projects.

Currently, this project is used to supply built-in functions for x86, x86_64, arm, and arm64 platforms.

If you are interested in contributing to this project, please read the [`CONTRIBUTING` guide][10].

## Table of Contents

1. [About the Project](#about-the-project)
1. [Project Status](#project-status)
1. [Getting Started](#getting-started)
    1. [Requirements](#Requirements)
    1. [Getting the Source](#getting-the-source)
    1. [Building](#building)
    1. [Usage](#installation)
1. [Versioning](#versioning)
1. [How to Get Help](#how-to-get-help)
1. [Further Reading](#further-reading)
1. [Contributing](#contributing)
1. [License](#license)
1. [Authors](#authors)

## About the Project

This project wraps the llvm compiler-rt repository and enables users to use it in meson-based projects.

Modifications to the compiler-rt implementations are not anticipated, but if needed alternative implementations can be supplied by this project.

**[Back to top](#table-of-contents)**

## Project Status

This project builds the full suite of compiler-rt functions for x86, x86_64, arm, and arm64 processors.

**[Back to top](#table-of-contents)**

## Getting Started

### Requirements

* [Meson](#meson-build-system) is the build system
* [`git-lfs`][7] is used to store binary files in this repository
* `make` is needed if you want to use the Makefile shims
* You'll need some kind of compiler for your target system.
    - This repository has been tested with:
        - gcc
        - arm-none-eabi-gcc
        - Apple clang
        - Mainline clang

#### git-lfs

This project stores some files using [`git-lfs`](https://git-lfs.github.com).

To install `git-lfs` on Linux:

```
sudo apt install git-lfs
```

To install `git-lfs` on OS X:

```
brew install git-lfs
```

Additional installation instructions can be found on the [`git-lfs` website](https://git-lfs.github.com).

#### Meson Build System

The [Meson][meson] build system depends on `python3` and `ninja-build`.

To install on Linux:

```
sudo apt-get install python3 python3-pip ninja-build
```

To install on OSX:

```
brew install python3 ninja
```

Meson can be installed through `pip3`:

```
pip3 install meson
```

If you want to install Meson globally on Linux, use:

```
sudo -H pip3 install meson
```

### Getting the Source

This project uses [`git-lfs`](https://git-lfs.github.com), so please install it before cloning. If you cloned prior to installing `git-lfs`, simply run `git lfs pull` after installation.

This project is [hosted on GitHub](https://github.com/embeddedartistry/compiler-rt). You can clone the project directly using this command:

```
git clone --recursive git@github.com:embeddedartistry/compiler-rt.git
```

If you don't clone recursively, be sure to run the following command in the repository or your build will fail:

```
git submodule update --init
```

### Building

The library can be built by issuing the following command:

```
make
```

This will build all targets for your current architecture.

You can clean builds using:

```
make clean
```

You can eliminate the generated `buildresults` folder using:

```
make purify
```

You can also use the `meson` method for compiling.

Create a build output folder:

```
meson buildresults
```

Then change into that folder and build targets by running:

```
ninja
```

At this point, `make` would still work.

#### Cross-compiling

Cross-compilation is handled using `meson` cross files. Example files are included in the [`build/cross`](build/cross/) folder. You can write your own cross files for your specific platform (or open an issue and we can help you).

Cross-compilation must be configured using the meson command when creating the build output folder. For example:

```
meson buildresults --cross-file build/cross/gcc/arm/gcc_arm_cortex-m4.txt
```

Following that, you can run `make` (at the project root) or `ninja` (within the build output directory) to build the project.

Tests will not be cross-compiled. They will be built for the native platform.

### Usage

If you don't use `meson` for your project, the best method to use this project is to build it separately and copy the headers and library contents into your source tree.

* Copy the `include/` directory contents into your source tree.
* Library artifacts are stored in the `buildresults/` folder
* Copy the desired library to your project and add the library to your link step.

Example linker flags:

```
-Lpath/to/libcompiler_rt.a -lcompiler_rt
```

If you're using `meson`, you can use `compiler-rt` as a subproject. Place it into your subproject directory of choice and add a `subproject` statement:

```
compiler_rt = subproject('compiler-rt')
```

You will need to promote the subproject dependencies to your project:

```
compiler_rt_builtins_dep = compiler_rt.get_variable('compiler_rt_builtins_dep')
compiler_rt_builtins_native_dep = compiler_rt.get_variable('compiler_rt_builtins_native_dep')
```

You can use the dependency for your target library configuration in your `executable` declarations(s) or other dependencies. For example:

```
blinky_nrf52dk_platform_dep = declare_dependency(
    include_directories: blinky_nrf52dk_platform_inc,
    dependencies: [
        nf52dk_blinky_hw_platform_dep,
        blinky_demo_platform_dep,
        libmemory_freelist_dep,
        libc_dep,
        libcxxabi_dep,
        libcxx_full_dep,
        compiler_rt_builtins_dep, # <------- compiler-rt dependency added
    ],
    link_args: [
        '-L' + meson.current_source_dir(),
        '-Tblinky_gcc_nrf52.ld',
    ],
    sources: files('platform.cpp'),
)
```

## Versioning

This project itself is unversioned and simply pulls in the latest compiler-rt commits periodically.

## How to Get Help

Provide any instructions or contact information for users who need to get further help with your project.

## Contributing

Provide details about how people can contribute to your project. If you have a contributing guide, mention it here. e.g.:

We encourage public contributions! Please review [CONTRIBUTING.md](docs/CONTRIBUTING.md) for details on our code of conduct and development process.

**[Back to top](#table-of-contents)**

## Further Reading

Provide links to other relevant documentation here

**[Back to top](#table-of-contents)**

## License

This build project is licensed under the MIT license.

Compiler-rt (and the llvm project in general) are released under [a modified Apache 2.0 license](compiler-rt/LICENSE.txt.

## Authors

* **[Phillip Johnston](https://github.com/phillipjohnston)** - *Initial work* - [Embedded Artistry](https://github.com/embeddedartistry)

**[Back to top](#table-of-contents)**
