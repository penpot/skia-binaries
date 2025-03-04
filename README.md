# skia-binaries
Prebuilt binaries generated downloaded by skia-binding's build.rs script.

[This repository's releases tab](https://github.com/penpot/skia-binaries/releases) contains binary builds for Skia, the skia-bindings library, and the Rust bindings `src/bindings.rs`. 

## To build a new release:
- Update the version to build in the TAG variable of the build_skia script
- Execute the build_skia script inside the penpot devenv environment

## Extras required to be installed in the devenv environment
```
apt-get install ninja-build
apt-get install clang-16
apt-get install jq
```
