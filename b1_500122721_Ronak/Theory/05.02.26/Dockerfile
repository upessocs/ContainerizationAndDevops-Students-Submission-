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
