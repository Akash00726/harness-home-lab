# Sample Application

A simple Flask application used to learn Harness Continuous Delivery.

## Endpoints

| Endpoint | Description |
|----------|-------------|
| / | Home |
| /health | Health Check |
| /version | Application Version |
| /env | Environment Details |

## Run Locally

```bash
pip install -r requirements.txt
python app.py
```

## Build Docker Image

```bash
docker build -t sample-app:v1.0.0 .
```

## Run Container

```bash
docker run -p 5000:5000 sample-app:v1.0.0
```