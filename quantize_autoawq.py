# !pip install autoawq

import argparse

from awq import AutoAWQForCausalLM
from transformers import AutoTokenizer

parser = argparse.ArgumentParser()
parser.add_argument("--pretrained_model_dir", type=str)
parser.add_argument("--quantized_model_dir", type=str, default="Meta-Llama-3-8B-Instruct-zh-10k-AWQ")
args = parser.parse_args()

pretrained_model_dir = args.pretrained_model_dir
quantized_model_dir = args.quantized_model_dir
quantize_config = { "zero_point": True, "q_group_size": 128, "w_bit": 4, "version": "GEMM" }

model = AutoAWQForCausalLM.from_pretrained(pretrained_model_dir)
tokenizer = AutoTokenizer.from_pretrained(pretrained_model_dir, trust_remote_code=True)

model.quantize(tokenizer, quant_config=quantize_config)

model.save_quantized(quantized_model_dir, use_safetensors=True)
tokenizer.save_pretrained(quantized_model_dir)