[![Docker Image CI](https://github.com/mosakrm0/DevOps-Project/actions/workflows/ci.yml/badge.svg)](https://github.com/mosakrm0/DevOps-Project/actions/workflows/ci.yml)

# SimpleApp 

A lightweight Python web application containerized with Docker and deployable to Kubernetes via Minikube.

---

## Project Structure

```
├── .github/workflows/    # CI/CD pipeline definitions
├── Dockerfile            # Container image build instructions
├── app.py                # Main application entry point
├── req.txt               # Python dependencies
├── script.sh             # Minikube deployment script
└── README.md
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Python 3.12 |
| Base Image | `python:3.12-alpine` |
| Container Runtime | Docker / Podman |
| Orchestration | Kubernetes (Minikube) |
| CI/CD | GitHub Actions |
| Registry | Docker Hub (`mosakrmoov/mosakrmoov`) / GHCR |

---

## Docker

### Build the image locally

```bash
docker build -t simpleapp .
```

### Run the container

```bash
docker run -p 5000:5000 simpleapp
```

---

## Deploy to Minikube

The `script.sh` script automates the full local Kubernetes deployment. It will:

1. Install dependencies (`curl`, `minikube`, `podman`, `kubectl`)
2. Start a Minikube cluster using the Podman driver (rootless mode)
3. Deploy the app with **3 replicas**
4. Expose it via a `LoadBalancer` service on port `80` → `5000`
5. Open the service in your browser

```bash
chmod +x script.sh
./script.sh
```

### Manual deployment

```bash
# Start Minikube
minikube start --driver=podman

# Deploy
kubectl create deployment simpleapp --image=ghcr.io/mosakrm0/simpleapp --replicas=3
kubectl expose deployment simpleapp --port=80 --target-port=5000 --type=LoadBalancer

# Access the service
minikube service simpleapp
```

### Verify the deployment

```bash
kubectl get pods
kubectl get services
kubectl get deployments
```

---

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/`) triggers on every push or pull request to `main`.

**Pipeline steps:**

1. **Checkout** — pulls the latest source code
2. **Login to Docker Hub** — authenticates using repository secrets
3. **Build & Push** — builds the Docker image and pushes it to Docker Hub

### Required Secrets & Variables

Configure these in your GitHub repository settings under **Settings → Secrets and variables → Actions**:

| Name | Type | Description |
|---|---|---|
| `DOCKERHUBT` | Secret | Docker Hub access token |
| `DOCKERUSER` | Variable | Docker Hub username |

---

## Getting Started (Quick Start)

### Prerequisites

- Docker or Podman
- `kubectl`
- Minikube
- A Linux-based environment (Ubuntu recommended)

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/mosakrm0/simpleapp.git
cd simpleapp

# 2. Install dependencies
pip install -r req.txt

# 3. Run locally
python app.py

# 4. Or deploy to Minikube
./script.sh
```

---

## Dependencies

All Python dependencies are listed in `req.txt` and installed during the Docker build:

```dockerfile
RUN pip install --no-cache-dir -r req.txt
```

---

> **Note:** The CI pipeline uses `[skip ci]` tags in commit messages to bypass builds when needed.

---

