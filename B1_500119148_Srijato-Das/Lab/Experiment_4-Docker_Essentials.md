# Experiment 4: Docker Essentials

---

## Table of Contents

1. [Objective](#objective)
2. [Prerequisites](#prerequisites)
3. [Part A — Flask application](#part-a---flask-application-my-flask-app)
4. [Part B — Optimization: Multi-stage build](#part-b---optimization-multi-stage-build)
5. [Part C — Tagging and publishing to Docker Hub](#part-c---tagging-and-publishing-to-docker-hub)
6. [Part D — Node.js App](#part-d---nodejs-app)
7. [Troubleshooting & Best Practices](#troubleshooting--best-practices)
8. [Conclusion](#conclusion)
9. [Additional Resources](#additional-resources)

---

## Objective

Master core Docker skills including containerizing applications with Dockerfile, optimizing builds with .dockerignore, implementing multi-stage builds, and publishing verified images to Docker Hub. This lab uses a simple Python Flask app and a small Node.js example to demonstrate patterns.

---

## Prerequisites

- WSL2 / Ubuntu or Linux environment
- Docker Engine installed and running
- Docker Hub account (for publishing)
- Basic familiarity with Python and Node.js

---

## Part A — Flask application (my-flask-app)

A lightweight Flask app is created, containerized, optimized, and published.

Project structure:

```
my-flask-app/
├── app.py
├── requirements.txt
├── Dockerfile
├── Dockerfile.multistage
└── .dockerignore
```

1) Create project directory and files
```bash
mkdir my-flask-app
cd my-flask-app
```

![Project directory created](../Asset/Lab_4/4-1.png)

2) app.py (simple web server)
```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Docker!"

@app.route('/health')
def health():
    return "OK"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

![app.py created](../Asset/Lab_4/4-2.png)

3) requirements.txt
```
Flask==2.3.3
```

![requirements](../Asset/Lab_4/4-3.png)

4) .dockerignore — keep the build context small
```
__pycache__/
*.pyc
.env
.venv
.vscode/
.idea/
.git/
.DS_Store
logs/
```

![dockerignore](../Asset/Lab_4/4-4.png)

5) Dockerfile (simple)
```dockerfile
# Use Python base image
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
```

![Dockerfile](../Asset/Lab_4/4-5.png)

6) Build and run image
- Build image: `docker build -t my-flask-app:latest .`

![build output](../Asset/Lab_4/4-6.png)

- Verify images: `docker images`

![docker images list](../Asset/Lab_4/4-7.png)

- Run container: `docker run -d -p 5000:5000 --name flask-container my-flask-app:latest`

![container running](../Asset/Lab_4/4-8.png)

- Test app: `curl http://localhost:5000`

![curl output or browser view](../Asset/Lab_4/4-9.png)
![Running Container Logs](../Asset/Lab_4/4-10.png)
![Container Process Monitoring](../Asset/Lab_4/4-11.png)

---

## Part B — Optimization: Multi-stage build

Multi-stage builds separate build-time dependencies from the runtime image.

Dockerfile.multistage:
```dockerfile
# STAGE 1: Builder
FROM python:3.9-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# STAGE 2: Runtime
FROM python:3.9-slim
WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY app.py .
# Create non-root user for security
RUN useradd -m -u 1000 appuser
USER appuser
EXPOSE 5000
CMD ["python", "app.py"]
```

![multistage Dockerfile](../Asset/Lab_4/4-12.png)

Build and compare:
- `docker build -f Dockerfile.multistage -t flask-multistage:latest .`

![multistage build output](../Asset/Lab_4/4-13.png)
![Multistage Image Verification](../Asset/Lab_4/4-14.png)

---

## Part C — Tagging and publishing to Docker Hub

1) Login to Docker Hub: `docker login`

2) Tag the image for your Docker Hub repository (replace username):
- `docker tag my-flask-app:latest username/my-flask-app:1.0`
- `docker tag flask-multistage:latest username/my-flask-app:multistage`

![tagging](../Asset/Lab_4/4-15.png)

3) Push images:
- `docker push username/my-flask-app:1.0`
- `docker push username/my-flask-app:multistage`

![Docker Hub Push Verification](../Asset/Lab_4/4-16.png)
![Docker Hub Repository View](../Asset/Lab_4/4-17.png)

---

## Part D — Node.js App

A minimal Node.js Express app demonstrates a multi-stage pattern for Node.

Project structure:
```
my-node-app/
├── app.js
├── package.json
└── Dockerfile
```

app.js:
```js
const express = require('express');
const app = express();
const port = 3000;
app.get('/', (req, res) => res.send('Hello from Node.js Docker!'));
app.get('/health', (req, res) => res.json({ status: 'healthy' }));
app.listen(port, () => console.log(`Server running on port ${port}`));
```

![Files](../Asset/Lab_4/4-15.png)

Dockerfile (recommended pattern):
```dockerfile
# STAGE 1: Builder
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY app.js .

# STAGE 2: Runtime
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app .
# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
EXPOSE 3000
CMD ["node", "app.js"]
```

Build and run:
- `docker build -t my-node-app .`
- `docker run -d -p 3000:3000 --name node-container my-node-app`

![Docker Build](../Asset/Lab_4/4-18.png)
![Docker Build](../Asset/Lab_4/4-19.png)

---

## Troubleshooting & Best Practices

- Use .dockerignore to keep build context minimal.
- Prefer pinned dependency versions in requirements.txt and package.json for reproducibility.
- Use multi-stage builds to reduce surface area and split build/runtime concerns.
- Run containers as non-root where possible.
- Clean up resources: `docker system prune -a` (careful: removes images/containers not in use).

---

## Conclusion

This lab demonstrates a full container lifecycle: local app creation, Dockerfile authoring, optimization with .dockerignore and multi-stage builds, image inspection, tagging, and publishing to Docker Hub.

---

## Additional Resources

- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Multi-stage Build Documentation](https://docs.docker.com/build/building/multi-stage/)
- [Docker Hub Official Repositories](https://hub.docker.com/search?type=image&image_filter=official)

---
