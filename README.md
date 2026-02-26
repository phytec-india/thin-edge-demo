# Thin-edge Demo

This repository provides a comprehensive demo for integrating Modbus-based smart energy meters with industrial IoT (IIoT) gateways using Thin-edge.io. The solution enables seamless data acquisition from Modbus RTU devices and publishes processed measurements to various cloud platforms (AWS IoT, Cumulocity, Thingsboard) or local MQTT brokers.

## Features

- **Modbus RTU Support:** Communicates with energy meters over RS485 serial interfaces.
- **MQTT Integration:** Publishes data to MQTT brokers (e.g., Mosquitto, AWS IoT).
- **Flexible Configuration:** Supports configurable register maps, baud rates, and MQTT topics.
- **Cloud and Edge Compatibility:** Works with both local and cloud monitoring systems.
- **Logging and Diagnostics:** Built-in logging for troubleshooting and development.

## Repository Structure

```
application/
  Modbus-Smart-Energy-Meter-Plugin/
    main.py
    modbus_plugin/
    requirements.txt
    docker-compose.yml
    Dockerfile
    ...
bsp/
  setupTE.sh
  patches/
  ...
docs/
  source/
  Makefile
  ...
```

- **application/Modbus-Smart-Energy-Meter-Plugin/**: Main Python application and plugin code.
- **bsp/**: Yocto BSP integration scripts and patches for PHYTEC Tauri-L i.MX8MM.
- **docs/**: Sphinx-based documentation for setup, usage, and architecture.

## Getting Started

For getting started with this demo, please refer to the official documentation:

https://phytec-india.github.io/thin-edge-demo/

## Supported Energy Meters

- Selec MFM3833A
- SDM230-MODBUS-MID V2
- (Extendable to other Modbus RTU meters)

## Cloud Platforms Supported

- AWS IoT Core
- Cumulocity IoT
- Thingsboard

## License

Copyright (c) PHYTEC INDIA

See [LICENSE](LICENSE) for details.

## Support

For issues or questions, please open an issue on this repository or contact PHYTEC INDIA support.
