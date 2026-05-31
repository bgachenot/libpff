# Build Requirements for libpff-python

Building libpff-python from source requires system-level development tools in addition to Python.

## Quick Install (Recommended)

Use pre-built wheels from PyPI - no compilation needed:

```bash
pip install libpff-python
```

This works on all platforms and is much faster than building from source.

## Building from Source

If you need to build from source, install the required build tools:

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install -y \
    autoconf \
    automake \
    autopoint \
    build-essential \
    libtool \
    pkg-config \
    python3-dev

pip install libpff-python
```

### Alpine Linux

```bash
apk add --no-cache \
    autoconf \
    automake \
    autopoint \
    build-base \
    libtool \
    pkg-config \
    python3-dev

pip install libpff-python
```

### macOS

```bash
brew install autoconf automake gettext libtool pkg-config

pip install libpff-python
```

### Windows

Visual Studio 2015 or later with C++ build tools, plus:
- Install autotools (MSYS2/MinGW recommended)
- Or use pre-built wheels (recommended)

## Troubleshooting Build Failures

### "configure not found" or "autotools not found"

Install the build tools listed above for your platform.

### "python3-dev" or "python3-devel" not found

You need Python development headers:
- **Ubuntu/Debian**: `sudo apt install python3-dev`
- **Alpine**: `apk add python3-dev`
- **Fedora/CentOS**: `sudo dnf install python3-devel`
- **macOS**: Should be included with Homebrew Python

### On Alpine: "configure: cannot run C compiled programs"

Ensure you have:
```bash
apk add musl-dev gcc
```

## Development Installation

For development, use editable install:

```bash
git clone https://github.com/bgachenot/libpff.git
cd libpff
pip install -e .
```

This installs the package in development mode, so code changes take effect immediately.

## Pre-built Wheels

Pre-built wheels are available for:
- Linux (x86_64, ARM64) - glibc and musl
- macOS (Intel, Apple Silicon)
- Windows (x86_64, ARM64)

These are built automatically on GitHub Actions and published to PyPI.

## References

- [Python Development Setup](https://docs.python.org/3/library/development.html)
- [Autotools Manual](https://www.gnu.org/software/autoconf/manual/)
