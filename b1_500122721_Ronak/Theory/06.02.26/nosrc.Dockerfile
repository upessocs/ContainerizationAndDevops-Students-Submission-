FROM python:3.10-slim

WORKDIR /app

RUN pip install numpy

CMD ["python", "app.py"]