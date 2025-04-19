from flask import Flask, request, jsonify
from dotenv import load_dotenv
import os
import requests
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('app.log'),
        logging.StreamHandler()
    ]
)

# Load environment variables
load_dotenv()

app = Flask(__name__)

def chat_with_model(token, message):
    url = os.getenv('IP') + '/api/chat/completions'
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json'
    }
    data = {
        "model": "llama3.2:latest",
        "messages": [
            {
                "role": "user",
                "content": message
            }
        ]
    }
    response = requests.post(url, headers=headers, json=data)
    return response.json()

@app.route('/')
def hello():
    logging.info("Root endpoint accessed")
    return 'Hello Jupiter!'

@app.route('/chat', methods=['POST'])
def chat():
    try:
        data = request.json
        message = data.get('message', '')
        logging.info(f"Received chat message: {message}")
        
        # Get the API key from environment variables
        api_key = os.getenv('API_KEY')
        if not api_key:
            logging.error("API_KEY not found in environment variables")
            return jsonify({'error': 'API key not configured'}), 500
            
        # Make the request to Open Web UI
        logging.info("Making request to Open Web UI")
        response = chat_with_model(api_key, message)
        
        logging.info("Successfully received response from Open Web UI")
        return jsonify(response)
            
    except Exception as e:
        logging.error(f"Error in chat endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("8000"), debug=True)

