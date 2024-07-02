#!/bin/bash
curl http://localhost:11434/api/chat -d '{
  "model": "llama3:zh",
  "messages": [
    { "role": "user", "content": "你好，你是谁？" }
  ]
}'