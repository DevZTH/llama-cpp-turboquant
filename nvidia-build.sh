#!/usr/bin/env bash
#CUDA_ARCH=86 ./nvidia-build.sh   # RTX 30xx
#CUDA_ARCH=75 ./nvidia-build.sh   # RTX 20xx/Turing
#CUDA_ARCH=120a ./nvidia-build.sh # RTX 50xx/Blackwell

set -euo pipefail

BUILD_DIR="${BUILD_DIR:-build-cuda-turbo-gcc15}"
CUDA_ARCH="${CUDA_ARCH:-89}"
JOBS="${JOBS:-16}"
CUDA_HOST_COMPILER="${CUDA_HOST_COMPILER:-/usr/bin/g++-15}"

if [[ ! -x "${CUDA_HOST_COMPILER}" ]]; then
  echo "error: CUDA host compiler not found: ${CUDA_HOST_COMPILER}" >&2
  echo "hint: on Arch, install it with: sudo pacman -S gcc15" >&2
  exit 1
fi

export NVCC_CCBIN="${CUDA_HOST_COMPILER}"

cmake -S . -B "${BUILD_DIR}" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DGGML_CUDA=ON \
  -DGGML_CUDA_FA=ON \
  -DGGML_CUDA_GRAPHS=ON \
  -DGGML_NATIVE=OFF \
  -DCMAKE_CUDA_HOST_COMPILER="${CUDA_HOST_COMPILER}" \
  -DCMAKE_CUDA_FLAGS=-std=c++17 \
  -DCMAKE_CUDA_ARCHITECTURES="${CUDA_ARCH}" \
  -DLLAMA_BUILD_TESTS=OFF \
  -DGGML_ALL_WARNINGS=OFF \
  -DGGML_ALL_WARNINGS_3RD_PARTY=OFF \
  -DGGML_CCACHE=OFF

cmake --build "${BUILD_DIR}" --target \
  llama-cli \
  llama-server \
  llama-bench \
  llama-perplexity \
  llama-quantize \
  llama-imatrix \
  llama-gguf-split \
  -j "${JOBS}"

"./${BUILD_DIR}/bin/llama-cli" --version
"./${BUILD_DIR}/bin/llama-cli" --list-devices
