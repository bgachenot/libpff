# Publishing libpff-python to PyPI

This document explains how the libpff-python package is configured for distribution on PyPI.

## Configuration Files

### `pyproject.toml`
- **Purpose**: Main build configuration for modern Python packaging
- **Generated from**: `pyproject.toml.in` (template)
- **Contains**: Build requirements, project metadata, Python version support
- **Auto-generated**: version is extracted from `configure.ac`

### `setup.py`
- **Purpose**: Fallback for older build systems
- **Delegates**: All configuration to `pyproject.toml` via `setup()` call
- **Status**: Minimal, modern approach

### `MANIFEST.in`
- **Purpose**: Specifies which files to include in source distribution
- **Includes**: Source code, documentation, configuration files
- **Excludes**: Build artifacts, git metadata

### `README.md`
- **Purpose**: Python-specific documentation for PyPI
- **Contents**: Installation, usage examples, platform support
- **Original README**: Preserved as `README` for full project documentation

## Build & Distribution

### Local Building

```bash
# Install build tools
pip install build twine

# Build both wheel and source distribution
python -m build

# This creates:
# - dist/libpff_python-*.whl (compiled wheel)
# - dist/libpff_python-*.tar.gz (source distribution)
```

### Building on Different Platforms

**Ubuntu/Debian:**
```bash
sudo apt install autoconf automake autopoint build-essential libtool pkg-config python3-dev
python -m build
```

**Alpine Linux:**
```bash
apk add autoconf automake autopoint build-base libtool pkg-config python3-dev
python3 -m build
```

**macOS:**
```bash
brew install autoconf automake gettext libtool pkg-config
python -m build
```

## GitHub Actions Workflow

The `.github/workflows/build_wheel.yml` workflow:

1. **Builds on multiple platforms:**
   - Ubuntu (x86_64, ARM64)
   - macOS (Intel, Apple Silicon)
   - Windows (x86_64, ARM64)
   - Alpine Linux (musl libc - specifically for compatibility)

2. **Generates distributions:**
   - Source distribution (sdist) from Ubuntu
   - Binary wheels (bdist_wheel) from all platforms

3. **Publishes automatically on release:**
   - On `release` event with `published` action
   - First publishes to TestPyPI for validation
   - Then publishes to production PyPI

## Publishing to PyPI

### Prerequisites

1. **Create PyPI Account**: https://pypi.org/account/register/
2. **Create API Token**: https://pypi.org/manage/account/token/
3. **Add to Repository Secrets**: `PYPI_API_TOKEN`

### Automatic Publishing

Publishing is **automatic** when you create a release:

```bash
# Create a version tag
git tag -a v20260526 -m "Release version 20260526"
git push origin v20260526

# Then create a release on GitHub (or use gh CLI)
gh release create v20260526 --draft  # First as draft
# Edit release and publish
```

The GitHub Actions workflow will:
1. Build all wheels and source distribution
2. Test on TestPyPI
3. Publish to production PyPI

### Manual Publishing

For testing or manual releases:

```bash
# Build the distribution
python -m build

# Upload to TestPyPI first
python -m twine upload --repository testpypi dist/* \
    -u __token__ -p pypi-...your-token...

# Test installation
pip install --index-url https://test.pypi.org/simple/ libpff-python

# Upload to production PyPI
python -m twine upload dist/* \
    -u __token__ -p pypi-...your-token...
```

## Alpine Linux Compatibility

The package uses **memmove** instead of **memcpy** for memory operations:

- `memory.h`: Prefers `memmove` over `memcpy`
- `narrow_string.h`: Prefers `memmove` for string operations
- `wide_string.h`: Prefers `wmemmove` for wide character operations
- `pff_test_memory.c`: Test mock uses `memmove` via dlsym

**Why memmove?**
- Available on both glibc and musl (Alpine's libc)
- Handles overlapping memory regions safely
- More reliable via dlsym on Alpine Linux
- Fully backward compatible

## Version Management

The version is automatically extracted from `configure.ac`:

```bash
# To bump version:
# 1. Edit configure.ac, change AC_INIT version
# 2. Regenerate pyproject.toml:
sed "s/@VERSION@/$(grep 'AC_INIT' configure.ac | sed 's/.*\[\([0-9]*\)\].*/\1/')/g" pyproject.toml.in > pyproject.toml
# 3. Commit and tag
```

## Testing

### Local Installation

```bash
# Install from local directory (editable)
pip install -e .

# Verify installation
python -c "import pypff; print(pypff.__file__)"
```

### On Alpine

```bash
# Using Docker
docker run -it alpine:latest
apk add python3 pip
pip install libpff-python
```

## Troubleshooting

### Build fails on Alpine
- Ensure `build-base` (includes gcc, musl-dev) is installed
- Check that libtool and autotools are available
- Verify Python development headers are installed

### PyPI upload fails
- Verify API token is correctly set in GitHub secrets
- Check that package name isn't already reserved
- Ensure version number is unique (not previously published)

### Import fails after installation
- On Alpine: Verify the `memmove`-based symbols are available
- Run: `ldd /path/to/site-packages/pypff*.so`
- Check glibc vs musl compatibility

## References

- [Python Packaging Guide](https://packaging.python.org/)
- [PyPA setuptools Documentation](https://setuptools.pypa.io/)
- [PyPI Package Publishing](https://packaging.python.org/tutorials/packaging-projects/)
- [cibuildwheel Documentation](https://cibuildwheel.pypa.io/)
