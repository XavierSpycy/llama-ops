#!/bin/bash
MODEL_DIR="${1:-./Meta-Llama-3-8B-Instruct-zh-10k}"
MODEL_FILE="${2:-meta-llama-3-8b-instruct-zh-10k.Q8_0.gguf}"

docker run -d \
    -p 6006:6006 \
    -v "$MODEL_DIR:/models" \
    --gpus all ghcr.io/ggerganov/llama.cpp:server-cuda \
    -m "models/$MODEL_FILE" \
    -c 512 \
    --host 0.0.0.0 \
    --port 6006 \
    --n-gpu-layers 99