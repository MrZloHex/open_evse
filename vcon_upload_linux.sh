#!/bin/bash

# Get the token and did from the user arguments
TOKEN=$1
DID=$2
PATH=$3
CURL_CMD=/usr/bin/curl
# CURL_CMD=$(which curl)

response=$($CURL_CMD -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/rpc/config.set -d '{"config":{"host":{"arch":300,"mode":0}}')
if [[ $response != "true" ]]; then
  echo $response
  exit 1
fi


response=$($CURL_CMD -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/rpc/gpio.write -d '{"pin":5,"val":0}')
if [[ $response != "true" ]]; then
  echo $response
  exit 1
fi


response=$($CURL_CMD -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/rpc/gpio.write -d '{"pin":2,"val":1}')
if [[ $response != "true" ]]; then
  echo $response
  exit 1
fi


response=$($CURL_CMD -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/ota?hex=1 --data-binary @$PATH)
if [[ $response != *"success\":true"* ]]; then
  echo $response
  exit 1
fi


response=$($CURL_CMD -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/rpc/gpio.write -d '{"pin":2,"val":0}')
if [[ $response != "true" ]]; then
  echo $response
  exit 1
fi


response=$($CURL_CMD -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/rpc/gpio.write -d '{"pin":5,"val":1}')
if [[ $response != "true" ]]; then
  echo $response
  exit 1
fi


response=$($CURL_CMD -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/rpc/config.set -d '{"config":{"host":{"arch":210,"mode":3},"reboot":500}')
if [[ $response != "true" ]]; then
  echo $response
  exit 1
fi

echo "All commands executed successfully."
