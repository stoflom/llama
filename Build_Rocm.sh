#!/bin/bash

MAIN_DIR=/home/stoflom/Workspace/llama
SOURCE_DIR=$MAIN_DIR/llama.cpp

# Change to source directory
cd $SOURCE_DIR

# Git pull from remote branch master
git pull origin master

# Remove all files in the build directory
rm -rf build/

# Run CMake to set config
cmake -B build -DGGML_HIP=ON -DAMDGPU_TARGETS=gfx1103 -DCMAKE_CXX_FLAGS="-fpermissive" -DGGML_HIP_UMA=ON -DGGML_HIP_FLASH_ATTN=ON 
# Build
cmake --build build --config Release -j$(nproc)

