#!/bin/bash
# Assume you've installed torch, transformers, huggingface_hub (or modelscope)

ORIGINAL_DIR=$(pwd)

sudo apt install git -y
python3 -m pip install --upgrade pip

git clone https://github.com/hiyouga/LLaMA-Factory.git
cd LLaMA-Factory
git checkout ce17eccf451649728cf7b45312fd7f75d3a8a246
python3 -m pip install -r requirements.txt || exit 1

cd $ORIGINAL_DIR

MODEL_DIR=$(python3 finetune_llama-factory_lora_download_models.py) || exit 1

if [ -z "$MODEL_DIR" ]
then
  echo "Error: Model directory is empty"
  exit 1
fi

python3 finetune_llama-factory_lora_inference.py --model_dir "$MODEL_DIR" || exit 1

OUTPUT_DIR="${1:-$ORIGINAL_DIR/Meta-Llama-3-8B-Instruct-Adapter}"

MODEL_DIR=$(python3 finetune_llama-factory_lora_get_model_dir.py) || exit 1

export CUDA_DEVICE_MAX_CONNECTIONS=1
export NCLL_P2P_DISABLE="1"
export NCLL_IB_DISABLE="1"

# This step takes around 12 hours on a single RTX 4090D GPU
CUDA_VISIBLE_DEVICES=0 python3 LLaMA-Factory/src/train_bash.py \
    --stage sft \
    --do_train True \
    --model_name_or_path "$MODEL_DIR" \
    --preprocessing_num_workers 16 \
    --flash_attn auto \
    --dataset alpaca_zh,alpaca_gpt4_zh,oaast_sft_zh \
    --template llama3 \
    --lora_target q_proj,k_proj,v_proj,o_proj,gate_proj,up_proj,down_proj \
    --output_dir "$OUTPUT_DIR" \
    --overwrite_cache \
    --overwrite_output_dir \
    --per_device_train_batch_size 2 \
    --gradient_accumulation_steps 16 \
    --max_grad_norm 1.0 \
    --lr_scheduler_type cosine \
    --logging_steps 10 \
    --save_steps 5000 \
    --learning_rate 5e-5 \
    --num_train_epochs 3 \
    --finetuning_type lora \
    --fp16 \
    --lora_rank 8 \
    --report_to none

EXPORT_DIR="${2:-$ORIGINAL_DIR/Meta-Llama-3-8B-Instruct-zh-10k}"

python3 LLaMA-Factory/src/export_model.py \
    --model_name_or_path "$MODEL_DIR" \
    --adapter_name_or_path "$OUTPUT_DIR" \
    --template llama3 \
    --finetuning_type lora \
    --export_dir "$EXPORT_DIR" \
    --export_size 2 \
    --export_legacy_format false

python3 finetune_llama-factory_lora_inference.py --model_dir "$EXPORT_DIR" || exit 1