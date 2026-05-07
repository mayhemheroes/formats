# Build Stage
FROM rustlang/rust:nightly AS builder

# Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang curl

# Install Rust.
RUN cargo install cargo-fuzz

## Add the source code.
ADD . /formats
WORKDIR /formats

# Compile the fuzzers.
RUN cargo fuzz build --fuzz-dir /formats/x509-cert/fuzz

# Copy the fuzzers to the final image.
FROM ubuntu:20.04
COPY --from=builder /formats /formats