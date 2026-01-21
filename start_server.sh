#!/bin/bash

MAIN_DIR=/home/stoflom/Workspace/llama
SOURCE_DIR=$MAIN_DIR/llama.cpp
MODEL_DIR=/home/stoflom/.cache/llama.cpp

CONTEXT_SIZE=65534

#MODEL_FILE=bartowski_allura-forge_Llama-3.3-8B-Instruct-GGUF_allura-forge_Llama-3.3-8B-Instruct-Q4_K_M.gguf
MODEL_FILE=mradermacher_Huihui-Qwen3-Coder-30B-A3B-Instruct-abliterated-i1-GGUF_Huihui-Qwen3-Coder-30B-A3B-Instruct-abliterated.i1-Q6_K.gguf


MODEL=$MODEL_DIR/$MODEL_FILE

# Change to source directory
cd $SOURCE_DIR


#Below not needed if build for UMA
#export GGML_CUDA_ENABLE_UNIFIED_MEMORY=1
#8B
#build/bin/llama-server -m $MODEL  -fa on -ngl 33 -c 8192

#30B runs fine using 19GB  
#(could use ""-ngl 49"", but the default "-ngl auto" seems to do the same, "-fa on" may also be not needed since it was built in)
#build/bin/llama-server -hf mradermacher/Huihui-Qwen3-Coder-30B-A3B-Instruct-abliterated-i1-GGUF:Q4_K_M -fa on -c 32768 
build/bin/llama-server -m $MODEL -fa on -c $CONTEXT_SIZE -cram -1 
