
# This is what I had to do after chatting with Gemini

## 1) Install rocm
```bash
sudo dnf install rocm-hip rocm-opencl rocm-runtime rocm-smi rocminfo rocm-devel
```

## 2) Fix compile error due to later compiler version on fedora:
```bash
sed -i 's/T x\[ne\] = {0};/T x[ne] = {};/' ggml/src/ggml-cuda/mma.cuh
```

## 3) Set env variable for graphics card to be recognized by rocm, in .bashrc.d/all.sh
```bash
# Trick roc
export HSA_OVERRIDE_GFX_VERSION=11.0.2
```
> NOTE this step seems unnecessary

## 4) Ensure user has access to graphics hardware:
```bash
sudo usermod -aG video,render $USER
```

## 5) Set build config to use HIP and permissive compiler
```bash
cmake -B build -DGGML_HIP=ON -DAMDGPU_TARGETS=gfx1103 -DCMAKE_CXX_FLAGS="-fpermissive" -DGGML_HIP_UMA=ON -DGGML_HIP_FLASH_ATTN=OFF
```

## Build script (works fine)
```bash
#!/bin/bash

# Git pull from remote branch master
git pull origin master

# Remove all files in the build directory
rm -rf build/

# Run CMake and build the project
cmake -B build -DGGML_HIP=ON -DAMDGPU_TARGETS=gfx1103 -DCMAKE_CXX_FLAGS="-fpermissive" -DGGML_HIP_UMA=ON -DGGML_HIP_FLASH_ATTN=ON
cmake --build build --config Release -j$(nproc)
```

## 6) Build
```bash
cmake --build build --config Release -j$(nproc)
```

## 7) To run gemma 3.1 from top directory:
```bash
build/bin/llama-cli -hf ggml-org/gemma-3-1b-it-GGUF
```
> This will download the model from Hugging Face (`-hf` flag), it is stored in `~/.cache/llama.cpp`

Or with additional parameters:
```bash
build/bin/llama-cli -hf ggml-org/gemma-3-1b-it-GGUF -ngl 99 -t 8 -b 512 --ctx-size 16384
```

### On an APU like the 8945HS, the CPU and GPU share the same memory. You can get a massive speed boost by enabling Unified Memory Architecture (UMA) support during compilation so the system doesn't waste time copying data between "system" and "video" RAM using cmake flag: `-DGGML_HIP_UMA=ON`. This must be enabled in BIOS. (It is with 4GB reserved for the GPU).

## 8) To run Llama 3.2 model use:
```bash
# enable unified memory (not needed when compiled with -DGGML_HIP_UMA=ON)
export GGML_CUDA_ENABLE_UNIFIED_MEMORY=1

build/bin/llama-cli -hf bartowski/Llama-3.2-3B-Instruct-GGUF:Q4_K_M -ngl 99 -t 8 -b 512 --ctx-size 16384
```

> The `-fa` on flag seems to make a huge difference in memory use (Is it needed when compiled with `-DGGML_HIP_FLASH_ATTN=ON`?)

Or Llama3.3 8B:
```bash
build/bin/llama-cli -m ~/.cache/llama.cpp/bartowski_allura-forge_Llama-3.3-8B-Instruct-GGUF_allura-forge_Llama-3.3-8B-Instruct-Q4_K_M.gguf -fa on -ngl 33 -c 8192
```

Or QWEN3 30B (runs fine using about 20GB) (Use this for coding):
```bash
build/bin/llama-cli -hf mradermacher/Huihui-Qwen3-Coder-30B-A3B-Instruct-abliterated-i1-GGUF:Q4_K_M -fa on -c 32767  -ngl 49 --color on
```

## 9) Similar for server on port 8080 (default, else use e.g. `--port 8000`)
```bash
build/bin/llama-server -hf mradermacher/Huihui-Qwen3-Coder-30B-A3B-Instruct-abliterated-i1-GGUF:Q4_K_M -fa on -c 32768  -ngl 49
```
