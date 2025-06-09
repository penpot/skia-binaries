# skia-binaries
Prebuilt binaries generated downloaded by skia-binding's build.rs script.

[This repository's releases tab](https://github.com/penpot/skia-binaries/releases) contains binary builds for Skia, the skia-bindings library, and the Rust bindings `src/bindings.rs`. 

## To build a new release:
* Build the docker container
```
docker build --tag skia-builder .
```

* Launch it and build skia (TAG and TARGET are specified via env variables):

    - For wasm:
        ```
        docker run -v ./output:/output -e TAG=0.86.0 -e TARGET=wasm32-unknown-emscripten --rm -it --entrypoint /rust-skia/build_skia skia-builder
        ```
    - For non wasm:
        ```
        docker run -v ./output:/output -e TAG=0.86.0 -e TARGET=x86_64-unknown-linux-gnu --rm -it --entrypoint /rust-skia/build_skia skia-builder
        ```

And the results will be generated in the output folder
