# Multi-stage Dockerfile for libpff-python
# Stage 1: Builder
FROM python:3.11-slim AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    autopoint \
    build-essential \
    git \
    gettext \
    libtool \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Copy source
COPY . .

# Build wheel
RUN python -m pip install --upgrade pip setuptools wheel build && \
    python -m build --wheel

# Stage 2: Runtime
FROM python:3.11-slim

# Install runtime dependencies (minimal)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy wheel from builder
COPY --from=builder /build/dist/*.whl .

# Install the package
RUN pip install --upgrade pip && \
    pip install *.whl

# Verify installation
RUN python -c "import pypff; print(f'pypff installed: {pypff.__file__}')"

CMD ["python"]
