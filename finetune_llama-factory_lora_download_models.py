import json
import sys

try:
    # Try to download from huggingface_hub
    from huggingface_hub import snapshot_download
    model_dir = snapshot_download("meta-llama/meta-llama-3-8b-instruct")
except ImportError:
    # If huggingface_hub is not installed, try to download from modelscope
    try:
        from modelscope import snapshot_download
        model_dir = snapshot_download("LLM-Research/Meta-Llama-3-8B-Instruct")
    except Exception as e:
        print("Error downloading model: ", str(e))
        sys.exit(1)
except Exception as e:
    print("Error downloading model: ", str(e))
    sys.exit(1)
else:
    model_info = {"model_dir": model_dir}
    with open("model_info.json", "w") as file:
        json.dump(model_info, file, indent=4)
    print("Model directory saved to model_info.json")
    print(model_dir)