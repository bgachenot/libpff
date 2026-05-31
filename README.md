# libpff-python

Python bindings for libpff - a library to access Personal Folder File (PFF) and Offline Folder File (OFF) formats used by Microsoft Outlook.

## Installation

### From PyPI

```bash
pip install libpff-python
```

### From Source

```bash
git clone https://github.com/libyal/libpff.git
cd libpff
pip install -e .
```

## Features

- Read PFF/OFF files (PST, OST, PAB formats)
- Support for 32-bit ANSI and 64-bit Unicode formats
- Support for 64-bit with 4k pages and DEFLATE compression
- Item recovery capabilities
- Handles corrupted encrypted PFF files
- **Alpine Linux compatible** - Uses portable `memmove` instead of glibc-specific `memcpy`

## Platform Support

- Linux (glibc and musl/Alpine)
- macOS
- Windows
- Any POSIX-compliant system

## Build Requirements

### Ubuntu/Debian

```bash
sudo apt install autoconf automake autopoint build-essential libtool pkg-config python3-dev
```

### Alpine Linux

```bash
apk add autoconf automake autopoint build-base libtool pkg-config python3-dev
```

### macOS

```bash
brew install autoconf automake gettext libtool pkg-config
```

### Windows

Visual Studio 2015 or later with C++ build tools

## Usage

```python
import pypff

# Open a PFF file
pff_file = pypff.file()
pff_file.open("outlook.pst")

# Iterate through folders
for folder in pff_file.root_folder.sub_folders:
    print(f"Folder: {folder.name}")
    
    # Iterate through items in folder
    for item in folder.items:
        print(f"  Item: {item.name}")

pff_file.close()
```

## Documentation

- [Project Wiki](https://github.com/libyal/libpff/wiki/Home)
- [Building from Source](https://github.com/libyal/libpff/wiki/Building)
- [PFF Forensics](https://github.com/libyal/documentation/blob/main/PFF%20Forensics%20-%20analyzing%20the%20horrible%20reference%20file%20format.pdf)

## License

LGPL-3.0-or-later

## Status

Alpha - under active development
