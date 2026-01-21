#export GGML_CUDA_ENABLE_UNIFIED_MEMORY=1
#8B
#build/bin/llama-cli -m ~/.cache/llama.cpp/bartowski_allura-forge_Llama-3.3-8B-Instruct-GGUF_allura-forge_Llama-3.3-8B-Instruct-Q4_K_M.gguf -fa on -ngl 33 -c 8192

#30B runs fine using 19GB
#(could use ""-ngl 49"", but the default "-ngl auto" seems to do the same, "-fa on" may also be not needed since it was built in)
#build/bin/llama-cli -hf mradermacher/Huihui-Qwen3-Coder-30B-A3B-Instruct-abliterated-i1-GGUF:Q4_K_M -fa on -c 32767 --color on
build/bin/llama-cli -hf mradermacher/Huihui-Qwen3-Coder-30B-A3B-Instruct-abliterated-i1-GGUF:Q6_K -fa on -c 32767 --color on
