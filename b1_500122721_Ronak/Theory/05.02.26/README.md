# Containerising a Python Application using Docker 

## Objective 

The goal of this hands-on experiment is to strengthen understanding of containerization concepts such as:

- Base images
- Dependency installation inside containers
- Image naming and tagging
- Container creation and testing


## Problem Statement

A simple Python program is given that:

1. Takes a SAP ID as input
2. Compares it with a stored SAP ID 
3. Prints:

- **Matched** if both SAP IDs are the same
- **Not Matched** otherwise

The task is to containerize this application using Docker.

---

## Application Code (`app.py`)

```python
# Simple program to verify SAP ID 
# Focus of this task is containerization, not Python

import numpy as np  # dependency for learning purpose

stored_sapid = "500122721"

user_sap = input("Enter your SAP ID: ")

if user_sapid == stored_sapid:
    print("Matched")
else:
    print("Not Matched")
```
![](./Images/1.png)

## Dockerfile
```bash
# Use offical Python base image (Python 3.10+)
FROM python:3.10-slim

# Set working directory inside the container
WORKDIR /app

# Copy the Python program into the container
COPY app.py .

# Install required dependency (NumPy) inside container
RUN pip install numpy

# Run the Python program when container starts
CMD ["python", "app.py"]
```
![](./Images/2.png)

## Build Instructions

The Docker image must be  named and tagged as:

sapid-checker:500122721


## Build the image using:

```bash
docker build -t sapid-checker:500122721 .
```
![](./Images/3.png)

## Verify Image

To confirm the image is created successfully:
```bash
docker images
```

Output:
![](./Images/4.png)

## Run & Test Instructions

Run the container in interactive mode:

```bash
docker run -it sapid-checker:500122721
```

Output:
![](./Images/5.png)
## Verify Containers

To view running containers:
```bash
docker ps
```

To view all containers (including stopped):
```bash
docker ps -a
```
![](./Images/6.png)

## Conclusion

This experiment successfully demonstrates:

Use of official Python base images

Installing dependencies inside the Docker container

Correct image naming and tagging

Running and testing an interactive container application

The Python program was containerized and executed successfully using Docker.