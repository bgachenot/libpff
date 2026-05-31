# libpff-python Build Dependencies

## Build-Time Dependencies

### Autotools Suite
- `autoconf` - Generate configure script from configure.ac
- `automake` - Generate Makefile.in from Makefile.am
- `autopoint` - Manage gettext translations
- `libtool` - Handle shared library generation
- `gettext` - Internationalization support
- `pkg-config` - Manage compiler/linker flags

### Build Tools
- `gcc` (or `clang`) - C compiler
- `make` - Build automation
- `libc-dev` (glibc-devel on Debian/Ubuntu, musl-dev on Alpine)

### Python Development
- `python3-dev` (or `python3-devel` on some distros)
- `pip`
- `wheel`
- `setuptools`

## Runtime Dependencies

### Alpine Linux (musl libc)
```
ca-certificates  # SSL/TLS certificates
libssl3          # OpenSSL libraries
python3          # Python runtime
py3-pip          # Package manager
```

### Ubuntu/Debian (glibc)
```
ca-certificates
libssl3
python3
python3-pip
```

### macOS
```
openssl (via Homebrew)
python3 (via Homebrew or system)
```

### Windows
```
Visual C++ Runtime (vcredist)
OpenSSL (if needed)
Python 3.10+
```

## Installation Commands by Platform

### Ubuntu 22.04 / Debian 12

**Build:**
```bash
sudo apt-get update
sudo apt-get install -y \
    autoconf \
    automake \
    autopoint \
    build-essential \
    gettext \
    libtool \
    pkg-config \
    python3-dev \
    python3-pip \
    python3-wheel
```

**Runtime:**
```bash
sudo apt-get install -y \
    ca-certificates \
    python3 \
    python3-pip
```

### Alpine 3.19

**Build:**
```bash
apk add --no-cache \
    autoconf \
    automake \
    build-base \
    ca-certificates \
    gettext-dev \
    libtool \
    pkgconfig \
    python3-dev \
    py3-pip \
    py3-wheel
```

**Note:** Alpine uses `gettext-dev` (not `autopoint` separately) and `pkgconfig` (not `pkg-config`)

**Runtime:**
```bash
apk add --no-cache \
    ca-certificates \
    python3 \
    py3-pip
```

### macOS (Homebrew)

**Build:**
```bash
brew install \
    autoconf \
    automake \
    gettext \
    libtool \
    pkg-config
# Python usually comes with Homebrew
```

**Runtime:**
```bash
# Just Python
brew install python@3.11
```

### CentOS / RHEL / Fedora

**Build:**
```bash
sudo dnf install -y \
    autoconf \
    automake \
    gcc \
    gettext-devel \
    libtool \
    make \
    pkg-config \
    python3-devel
```

**Runtime:**
```bash
sudo dnf install -y \
    python3 \
    python3-pip
```

## Docker Images

### Using pre-built Dockerfile

**Debian-based:**
```bash
docker build -t libpff:debian -f Dockerfile .
```

**Alpine-based (smaller, musl-compatible):**
```bash
docker build -t libpff:alpine -f Dockerfile.alpine .
```

## Verification

After installation, verify by importing the module:

```bash
python3 -c "import pypff; print('pypff loaded successfully')"
```

Check the installation location:

```bash
python3 -c "import pypff; print(pypff.__file__)"
```

## Optional Features

- **DEFLATE compression support**: Requires zlib
- **Encryption support**: Requires OpenSSL
- **International characters**: Requires gettext/libiconv

These are typically included in the standard build.

## Minimal Runtime Image

For the smallest runtime image:

```dockerfile
FROM alpine:latest
RUN apk add --no-cache python3 py3-pip ca-certificates
COPY libpff-python*.whl .
RUN pip install *.whl
CMD ["python3"]
```

This creates an image of ~100MB for a fully functional libpff-python installation.
