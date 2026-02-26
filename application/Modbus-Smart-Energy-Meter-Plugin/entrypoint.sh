#!/bin/bash
set -e

case "$CLOUD_PROVIDER" in
  c8y)
    tedge config set mqtt.client.host localhost
    tedge config set mqtt.bind.port 8883
    tedge config unset mqtt.client.auth.key_file
    tedge config unset mqtt.client.auth.ca_file
    tedge config unset mqtt.client.auth.cert_file
    tedge config set device.id "$DEVICE_ID"
    tedge config set c8y.url "$C8Y_URL"
    tedge config set c8y.http "$C8Y_HTTP"
    tedge config set c8y.mqtt "$C8Y_MQTT"
    tedge config set c8y.root.cert_path "$C8Y_ROOT_CERT_PATH"
    tedge cert upload c8y --user "$C8Y_USER_ID" --password "$C8Y_PASSWORD"
    tedge connect c8y
    ;;
  aws)
    tedge config set mqtt.client.host localhost
    tedge config set mqtt.bind.port 8883
    sudo tedge config unset mqtt.client.auth.ca_file
    sudo tedge config unset mqtt.client.auth.cert_file
    sudo tedge config unset mqtt.client.auth.key_file
    tedge config set aws.url "$AWS_URL"
    tedge config set mqtt.client.auth.cert_file "$CLIENT_CERT"
    tedge config set mqtt.client.auth.key_file "$CLIENT_KEY"
    tedge connect aws
    ;;
  tb)
    tedge config set mqtt.client.host "$TB_HOST"
    tedge config set mqtt.bind.port "$TB_PORT"
    tedge config set mqtt.client.auth.ca_file "$CA_CERT"
    tedge config set mqtt.client.auth.cert_file "$CLIENT_CERT"
    tedge config set mqtt.client.auth.key_file "$CLIENT_KEY"
    ;;
  *)
    echo "Unknown or unset CLOUD_PROVIDER. Set CLOUD_PROVIDER to c8y, aws, or tb."
    exit 1
    ;;
esac

exec python3 main.py
