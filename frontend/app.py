from flask import Flask, jsonify
import requests

app = Flask(__name__)

PRODUCT_SERVICE_URL = "http://product-service:5001"

@app.route("/")
def home():
    return jsonify({
        "application": "Blue-Green Microservices",
        "service": "Frontend",
        "version": "v2"
    })

@app.route("/products")
def get_products():
    response = requests.get(f"{PRODUCT_SERVICE_URL}/products")
    return jsonify(response.json())

@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "service": "frontend"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)