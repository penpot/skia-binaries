# Based on https://github.com/rust-skia/rust-skia/blob/master/docker/linux/Dockerfile
FROM ghcr.io/pragmatrix/rust-skia-linux:latest

RUN apt-get update
RUN apt-get install -y jq

RUN set -ex; \
    cd emsdk; \
    ./emsdk install latest; \
    ./emsdk activate latest; \
    rustup target add wasm32-unknown-emscripten;

WORKDIR /rust-skia/
COPY build_skia /rust-skia/
