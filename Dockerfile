FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY requirements-ml.txt .
RUN pip install --no-cache-dir -r requirements-ml.txt

COPY backend ./backend
COPY frontend ./frontend
COPY ml ./ml
COPY models ./models
COPY README.md .

RUN mkdir -p /data

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 10000

CMD ["python", "-m", "uvicorn", "backend.app.main:app", "--host", "0.0.0.0", "--port", "10000"]

# Used when this Dockerfile is deployed as a single service (Render, Fly,
# a plain `docker run`) rather than via docker-compose, which overrides
# this with its own per-service `command:` for the multi-container stack.
CMD ["./entrypoint.sh"]
