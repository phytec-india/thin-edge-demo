# PHYTedge-EnergyMeter-Plugin

## Pre-requisite Installation

1. **Docker installation script**

   ```bash
   chmod +x docker_install.sh
   ```

   ```bash
   ./docker_install.sh
   ```

2. **Thin-Edge installation script**

   ```bash
   chmod +x tedge_install.sh
   ```

   ```bash
   ./tedge_install.sh
   ```

## How to Run (Native Installation)

1. **Create and activate a Python virtual environment:**

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

2. **Install dependencies:**

   ```bash
   pip install -r requirements.txt
   ```

3. **Run the application:**
   ```bash
   python3 main.py
   ```

---

## How to Run (Docker Compose)

**Recommended for simplicity and production use**

1. **Build and start the service:**

   ```bash
   sudo docker compose up
   ```

   - This will build the image (if needed) and start the container with the correct device and network settings.
   - The configuration is managed in `docker-compose.yml`.

2. **Stop the service:**
   Press `Ctrl+C` or run:
   ```bash
   sudo docker compose down
   ```

---

## How to Run (Manual Docker Command)

_Advanced/manual method_

1. **Build the Docker image:**
   ```bash
   docker build -t modbus-plugin .
   ```
2. **Run the Docker container:**
   ```bash
   docker run --device=/dev/ttyUSB0 --rm --network=host modbus-plugin
   ```
   - Adjust `--device` as needed for your Modbus serial port.

---

## Usage & Configuration

- The application reads Modbus data from a Selec MFM383A Energy meter and publishes to Cumulocity via Thin Edge MQTT.
- Serial port and Modbus parameters can be changed in `modbus_plugin/app.py`.

---

## Badges

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Docker](https://img.shields.io/badge/docker-ready-blue)

---

## Project Structure

- `modbus_plugin/` - Main application package
- `main.py` - Entrypoint script
- `requirements.txt` - Python dependencies
- `Dockerfile` - Containerization
- `modbus_plugin.service` - Example systemd service file

---

## License

MIT License
