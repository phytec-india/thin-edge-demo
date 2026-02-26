FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Install tedge CLI
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://thin-edge.io/install.sh | sh -s && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY modbus_plugin/ ./modbus_plugin/
COPY main.py ./
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]