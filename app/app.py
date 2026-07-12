from flask import Flask, jsonify
import os
import socket

app = Flask(__name__)

APP_NAME = os.getenv("APP_NAME", "Harness Home Lab")
APP_VERSION = os.getenv("APP_VERSION", "v1.0.0")
APP_ENV = os.getenv("APP_ENV", "development")
HOSTNAME = socket.gethostname()


@app.route("/")
def home():
    return jsonify({
        "application": APP_NAME,
        "version": APP_VERSION,
        "environment": APP_ENV,
        "hostname": HOSTNAME,
        "message": "Welcome to the Harness Home Lab!"
    })


@app.route("/health")
def health():
    return jsonify({
        "status": "UP"
    }), 200


@app.route("/version")
def version():
    return jsonify({
        "application": APP_NAME,
        "version": APP_VERSION
    })


@app.route("/env")
def environment():
    return jsonify({
        "application": APP_NAME,
        "environment": APP_ENV,
        "hostname": HOSTNAME
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)