# Based on https://github.com/rust-skia/rust-skia/blob/master/docker/linux/Dockerfile
FROM ghcr.io/pragmatrix/rust-skia-linux:latest

RUN apt-get update
RUN apt-get install -y jq

# python >= 3.10 can't be install via apt, so we need to download the standalone binary
RUN curl -L "https://github.com/astral-sh/python-build-standalone/releases/download/20260510/cpython-3.15.0b1+20260510-x86_64-unknown-linux-gnu-install_only.tar.gz" -o python.tar.gz \
    && mkdir -p /opt/python \
    && tar -xzf python.tar.gz -C /opt/python --strip-components=1 \
    && rm python.tar.gz

ENV PATH="/opt/python/bin:$PATH"

RUN set -ex; \
    cd emsdk; \
    ./emsdk install latest; \
    ./emsdk activate latest; \
    rustup target add wasm32-unknown-emscripten;

WORKDIR /rust-skia/
COPY build_skia /rust-skia/
