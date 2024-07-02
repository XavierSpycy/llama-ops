# Llama3Ops: From LoRa to Deployment with Llama3

```mermaid
flowchart TD;
    PretrainedLlama3[Pretrained Llama3]-->LLaMAFactory["LLaMA-Factory (FT)"];
    PretrainedLlama3-->PEFT["PEFT (FT)"];
    PretrainedLlama3-->Unsloth["Unsloth (FT)"];
    LLaMAFactory-->llamacpp-Q;
    LLaMAFactory-->AutoAWQ["AutoAWQ (Q)"];
    LLaMAFactory-->vLLM["vLLM (D)"];
    LLaMAFactory-->TensorRT-LLM["TensorRT-LLM (D)"];
    LLaMAFactory-->AutoGPTQ["AutoGPTQ (Q)"];
    llamacpp-Q["llama.cpp (Q)"]-->llamacpp-D["llama.cpp (D)"];
    llamacpp-Q-->ollama["ollama (D)"];
    llamacpp-D-->LangChain-RAG["LangChain (RAG)"];
    llamacpp-D-->LangChain-Agent["LangChain (Agent)"];
    llamacpp-D-->LlamaIndex["LlamaIndex (RAG)"];
   ```

> [!NOTE]
> FT: Fine-tuning, Q: Quantization, D: Deployment.

## Fine-tuning

- `LLaMA-Factory`

    Specify `OUTPUT_DIR` and `EXPORT_DIR` when executing the script; default values are `./Meta-Llama-3-8B-Instruct-Adapter` and `./Meta-Llama-3-8B-Instruct-zh-10k`.

    ```bash
    $ source ./finetune_llama-factory_lora.sh
    ```

## Quantization

- `llama.cpp`

    Example using `./Meta-Llama-3-8B-Instruct-zh-10k`:

    ```bash
    $ source ./quantize_llama.cpp.sh
    ```

- `AutoAWQ`

    Adjust the quantization settings as needed.

    ```bash
    $ python3 quantize_autoawq.py \
        --pretrained_model_dir /path/to/your-pretrain-model-dir \
        --quantized_model_dir /path/to/your-quantized_model_dir
    ```

- `AutoGPTQ`

    Modify the quantization settings and examples according to your requirements.

    ```bash
    $ python3 quantize_autogptq.py \
        --pretrained_model_dir /path/to/your-pretrain-model-dir \
        --quantized_model_dir /path/to/your-quantized_model_dir
    ```

## Deployment

- `llama.cpp`

    Assuming the GGUF file path is  `./Meta-Llama-3-8B-Instruct-zh-10k/meta-llama-3-8b-instruct-zh-10k.Q8_0.gguf`:

    Deploy via command line:

    ```bash
    $ source ./deploy_llama.cpp_cli.sh
    ```

    Or deploy using Docker (untested):

    ```bash
    $ source ./deploy_llama.cpp_docker.sh
    ```

    Test the deployment:

    ```bash
    $ source ./deploy_llama.cpp_test.sh
    ```

- `ollama`

    Preparation for deployment:

    ```bash
    $ source ./deploy_ollama_prepare.sh
    ```

    For initial deployment of a custom model:

    ```bash
    $ source ./deploy_ollama_create.sh
    ```

    This step involves configuring the `Modelfile`. An example is provided for guidance, which you can customize as needed.

    Host the LLM locally:

    ```bash
    $ source ./deploy_ollama.sh
    ```

    Single turn chat test:

    ```bash
    $ source ./deploy_ollama_test_chat.sh
    ```

    Multi-turn chat test:

    ```bash
    $ python3 deploy_ollama_test_chat-multi-turn.py
    ```

    Note: We use the OpenAI function call format in this `.py` file to interact with our model.

    Start the server first for sequential conversations:

    ```bash
    $ source ./deploy_ollama_server.sh
    ```

    Then run:

    ```bash
    $ source ./deploy_ollama.sh
    ```

    Subsequent steps remain the same.

## What will be available soon:
- Fine-tuning:
    - [ ] PEFT 
    - [ ] Unsloth

- Quantization: N / A

- Deployment:
    - [ ] TensorRT-LLM & Triton
    - [ ] vLLM

- RAG:
    - [ ] LangChain
    - [ ] LlamaIndex