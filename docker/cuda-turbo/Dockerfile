FROM archlinux:base

ARG LLAMA_BIN_DIR=docker/cuda-turbo/runtime-bin
ARG CUDA_LIB_DIR=docker/cuda-turbo/runtime-cuda-libs

RUN pacman -Syu --noconfirm --needed \
        brotli \
        gcc-libs \
        openssl \
        zlib \
        zstd \
    && pacman -Scc --noconfirm

COPY ${LLAMA_BIN_DIR}/ /opt/llama/bin/
COPY ${CUDA_LIB_DIR}/ /opt/llama/cuda/lib64/

ENV LD_LIBRARY_PATH=/opt/llama/bin:/opt/llama/cuda/lib64
ENV PATH=/opt/llama/bin:${PATH}
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

WORKDIR /models
EXPOSE 8080

ENTRYPOINT ["/opt/llama/bin/llama-server"]
