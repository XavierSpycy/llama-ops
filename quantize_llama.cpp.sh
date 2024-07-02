#!/bin/bash
ORIGINAL_DIR=$(pwd)

git clone https://github.com/ggerganov/llama.cpp.git || exit 1
cd llama.cpp || exit 1

sudo apt update || exit 1
sudo apt install g++ || exit 1

make || exit 1

cd $ORIGINAL_DIR

MODEL_DIR="${1:-$ORIGINAL_DIR/Meta-Llama-3-8B-Instruct-zh-10k}"

# python3 llama.cpp/convert-hf-to-gguf.py \
#     "$MODEL_DIR/" \
#     --outfile ./Meta-Llama-3-8B-Instruct-zh-10k/meta-llama-3-8b-instruct-zh-10k.gguf \
#     --outtype f16 || exit 1

python3 quantize_llama.cpp_hf2gguf/llama.cpp/convert-hf-to-gguf.py \
    "$MODEL_DIR/" \
    --outfile "$MODEL_DIR/meta-llama-3-8b-instruct-zh-10k.Q8_0.gguf" \
    --outtype q8_0 || exit 1

# Or
# llama.cpp/llama-quantize \
#     "$MODEL_DIR/meta-llama-3-8b-instruct-zh-10k.gguf" \
#     "$MODEL_DIR/meta-llama-3-8b-instruct-zh-10k.Q2_K.gguf" \
#     Q2_K