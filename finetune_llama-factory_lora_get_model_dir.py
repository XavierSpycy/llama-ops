import json

def main():
    with open("model_info.json", "r") as file:
        model_info = json.load(file)
    print(model_info["model_dir"])

if __name__ == "__main__":
    main()