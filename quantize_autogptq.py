# !git clone https://github.com/PanQiWei/AutoGPTQ.git 
# %cd AutoGPTQ
# !pip install -vvv --no-build-isolation -e .

import argparse

from transformers import AutoTokenizer, TextGenerationPipeline
from auto_gptq import AutoGPTQForCausalLM, BaseQuantizeConfig

parser = argparse.ArgumentParser()
parser.add_argument("--pretrained_model_dir", type=str)
parser.add_argument("--quantized_model_dir", type=str, default="Meta-Llama-3-8B-Instruct-zh-10k-GPTQ")
args = parser.parse_args()

pretrained_model_dir = args.pretrained_model_dir
quantized_model_dir = args.quantized_model_dir

tokenizer = AutoTokenizer.from_pretrained(pretrained_model_dir, use_fast=True)
examples = [
    tokenizer(
        "auto-gptq是一个易用的模型量化库，有着友好的APIs、基于GPTQ算法。"
    ),
    tokenizer(
        "落霞与孤鹜齐飞，秋水共长天一色。"
    ),
    tokenizer(
        "雄关漫道真如铁，而今迈步从头越。"
    ),
    tokenizer(
        "横空出世，莽昆仑，阅尽人间春色。飞起玉龙三百万，搅得周天寒彻。"
    )
]

quantize_config = BaseQuantizeConfig(
    bits=4,
    group_size=128,
    desc_act=True)

model = AutoGPTQForCausalLM.from_pretrained(pretrained_model_dir, quantize_config)

model.quantize(examples)
model.save_quantized(quantized_model_dir, use_safetensors=True)