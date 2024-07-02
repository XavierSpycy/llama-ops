# !pip install openai
from openai import OpenAI

def main():
    client = OpenAI(
        base_url="http://localhost:11434/v1/",
        api_key="EMPTY"
    )

    history = []
    
    while True:
        message = input("用户：")

        if message == "/bye":
            break

        history.append({"role": "user", "content": message})

        try:
            completions = client.chat.completions.create(
                model="llama3:zh",
                messages=history
            )

            response = completions.choices[0].message.content
            
            history.append({"role": "assistant", "content": response})
            
            print(f"助手：{response}")

        except Exception as e:
            print("Error: ", e)
            break

if __name__ == "__main__":
    main()