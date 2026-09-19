from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({
        "service": "Product Service",
        "version": "v2"
    })

@app.route("/products")
def products():
    return jsonify([
        {"id": 1, "name": "Laptop"},
        {"id": 2, "name": "Mobile"},
        {"id": 3, "name": "Headphones"}
    ])

@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "service": "product-service"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)