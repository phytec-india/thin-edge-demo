"""
modbus_plugin.app

This module provides a generic Modbus device interface for reading measurements and publishing them to Thin Edge MQTT topics. Device-specific parameters are configurable, enabling easy migration to new Modbus hardware.
Author: Dibyajyoti Jena
"""

import time
import struct
from pymodbus.client import ModbusSerialClient
import subprocess

class ModbusDevice:
    def __init__(self, config):
        self.config = config
        self.failure_count = 0
        self.alert_sent = False
        self.event_sent = False
        self.client = ModbusSerialClient(**config['connection'])

    def read_float(self, address, byte_order):
        """
        Reads a 32-bit floating point value from two consecutive Modbus input registers.

        Args:
            address (int): The starting register address to read from.
            byte_order (str): Byte order, either 'MSB' or 'LSB'.

        Returns:
            float or None: The floating point value read from the registers, or None if an error occurs.
        """
        try:
            response = self.client.read_input_registers(address=address, count=2, slave=self.config['slave'])
            if response.isError():
                raise Exception(f"Modbus error: {response}")
            self.failure_count = 0
            self.alert_sent = False
            if not self.event_sent:
                event_payload = [
                    "tedge", "mqtt", "pub", self.config['event_topic'],
                    self.config['event_message']
                ]
                subprocess.run(event_payload, check=True)
                print("Event Sent: Device is online")
                self.event_sent = True
            registers = response.registers
            raw = (registers[0] << 16) | registers[1]
            float_value = struct.unpack('>f', raw.to_bytes(4, byteorder='big'))[0]
            return float_value
        except Exception as e:
            print(f"Exception in Modbus read: {e}")
            self.failure_count += 1
            print(f"Modbus read failed ({self.failure_count}/{self.config['failure_threshold']})")
            if self.failure_count >= self.config['failure_threshold'] and not self.alert_sent:
                try:
                    alert_payload = [
                        "tedge", "mqtt", "pub", self.config['alert_topic'],
                        self.config['alert_message']
                    ]
                    subprocess.run(alert_payload, check=True)
                    print("Alert sent: Device has been shutdown.")
                    self.alert_sent = True
                    self.event_sent = False
                except Exception as e:
                    print(f"Failed to send alert: {e}")
            time.sleep(2)
            return None

    def send_measurement(self, name, value):
        """
        Publishes a measurement value to the ThingsBoard MQTT topic.

        Args:
            name (str): The name of the measurement (e.g., 'Voltage').
            value (float): The value to publish.
        """
        try:
            formatted_value = "{:.3f}".format(value)
            payload = f'{{"{name}": {formatted_value}}}'
            cmd = ["tedge", "mqtt", "pub", self.config['measurement_topic'], payload]
            subprocess.run(cmd, check=True)
            print(f"Sent {name}: {formatted_value}")
        except Exception as e:
            print(f"Failed to send {name} measurement: {e}")

    def run(self):
        """
        Main loop for connecting to the Modbus device, reading measurements, and publishing them periodically.
        """
        if self.client.connect():
            print(f"Connected to Modbus device {self.config['name']}. Press Ctrl+C to stop.")
            try:
                while True:
                    for meas in self.config['measurements']:
                        value = self.read_float(meas['address'], meas['byte_order'])
                        if value is not None:
                            self.send_measurement(meas['name'], value)
                        else:
                            print(f"Failed to read {meas['name']}")
                    time.sleep(self.config.get('interval', 2))
            except KeyboardInterrupt:
                print("\nStopping Modbus readings...")
                self.client.close()
        else:
            print("Failed to connect.")

DEVICE_CONFIG = {
    'name': 'SDM230',
    'slave': 1,
    'connection': {
        'port': '/dev/ttymxc3',
        'baudrate': 9600,
        'parity': 'N',
        'stopbits': 1,
        'bytesize': 8,
        'timeout': 2
    },
    'failure_threshold': 3,
    'event_topic': 'te/device/main///e/event_SelecMFM383A',
    'event_message': '{"text": "Selec MFM383A Energy meter is online/connected"}',
    'alert_topic': 'te/device/main///a/alert_SelecMFM383A',
    'alert_message': '{"text": "Selec MFM383A Energy meter has been shutdown", "severity": "critical"}',
    'measurement_topic': 'v1/devices/me/SEMtelemetry',
    'measurements': [
        {'name': 'Voltage', 'address': 0, 'byte_order': 'MSB'},
        {'name': 'Current', 'address': 6, 'byte_order': 'MSB'},
        {'name': 'Frequency', 'address': 70, 'byte_order': 'MSB'},
        {'name': 'Active Power', 'address': 12, 'byte_order': 'MSB'},
        {'name': 'Apparent Power', 'address': 18, 'byte_order': 'MSB'},
        {'name': 'Power Factor', 'address': 30, 'byte_order': 'MSB'},
        {'name': 'Energy', 'address': 342, 'byte_order': 'MSB'}
    ],
    'interval': 2
}

def main():
    device = ModbusDevice(DEVICE_CONFIG)
    device.run()
