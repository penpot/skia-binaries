# skia-binaries

Prebuilt binaries downloaded by skia-bindings' `binary-cache` build script.

[This repository's releases tab](https://github.com/penpot/skia-binaries/releases)
contains binary builds for Skia, the skia-bindings library, and the Rust
bindings `bindings.rs`.

## Build a new release

Build the docker image (Emscripten is pinned; override with
`--build-arg EMSCRIPTEN_VERSION=…` if needed):

```bash
docker build --tag skia-builder .
```

For aarch64 Linux targets, also build the arm64 image (the main one is
`x86_64` only):

```bash
docker build -f Dockerfile_aarch64 --tag skia-builder-aarch64 .
```

Run the build (`TAG` = rust-skia tag/commit, `TARGET` = cargo triple).
Artifacts land in `./output/`.

### Wasm (SIMD on by default)

```bash
docker run -v ./output:/output \
  -e TAG=0.153.3 \
  -e TARGET=wasm32-unknown-emscripten \
  --rm -it --entrypoint /rust-skia/build_skia skia-builder
```

Output name includes a `-simd` suffix when wasm SIMD is enabled, e.g.

`skia-binaries-<hash>-wasm32-unknown-emscripten-gl-svg-textlayout-binary-cache-webp-pdf-simd.tar.gz`

Disable SIMD:

```bash
docker run -v ./output:/output \
  -e TAG=0.153.3 \
  -e TARGET=wasm32-unknown-emscripten \
  -e WASM_SIMD=0 \
  --rm -it --entrypoint /rust-skia/build_skia skia-builder
```

### Native (Linux x86\_64)

```bash
docker run -v ./output:/output \
  -e TAG=0.153.3 \
  -e TARGET=x86_64-unknown-linux-gnu \
  --rm -it --entrypoint /rust-skia/build_skia skia-builder
```

### Native (Linux aarch64)

For arm64 Linux, e.g. the penpot devenv on Apple Silicon. Uses the
`skia-builder-aarch64` image:

```bash
docker run -v ./output:/output \
  -e TAG=0.153.3 \
  -e TARGET=aarch64-unknown-linux-gnu \
  --rm -it --entrypoint /rust-skia/build_skia skia-builder-aarch64
```

## Environment

| Variable | Default | Meaning |
|---|---|---|
| `TAG` | _(required)_ | rust-skia tag or commit |
| `TARGET` | _(required)_ | Cargo target triple |
| `SKIA_FEATURES` | `gl,svg,textlayout,binary-cache,webp,pdf` | Cargo features for `skia-safe` |
| `EMSCRIPTEN_VERSION` | `4.0.6` | emsdk version (match penpot devenv) |
| `WASM_SIMD` | `1` | For wasm targets: add `-msimd128` and `-simd` filename suffix |
| `EMCC_CFLAGS` | empty | Extra emcc flags (SIMD flags are appended when enabled) |

The archive also contains `build-info.txt` (tag, hash, target, features,
emscripten, simd flags) for later inspection.

## After publishing

Point `render-wasm` `SKIA_BINARIES_URL` (in `_build_env`, `lint`, `test`) at
the new asset URL. Keep `-msimd128` in `render-wasm` `EMCC_CFLAGS` when using
a `-simd` wasm archive.

