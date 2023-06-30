#!/bin/bash

# Get the token and did from the user arguments
TOKEN=$1
DID=$2
PATH=$3

response=$(/bin/curl -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/rpc/config.set -d '{"config":{"host":{"arch":300,"mode":0}}' -k)
if [[ $response != "true" ]]; then
  echo $response
  pause 10
  exit 1
fi


response=$(/bin/curl -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/rpc/gpio.write -d '{"pin":5,"val":0}' -k)
if [[ $response != "true" ]]; then
  echo $response
  pause 10
  exit 1
fi


response=$(/bin/curl -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/rpc/gpio.write -d '{"pin":2,"val":1}' -k)
if [[ $response != "true" ]]; then
  echo $response
  pause 10
  exit 1
fi


response=$(/bin/curl -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/ota?hex=1 --data-binary @$PATH -k)
if [[ $response != *"success\":true"* ]]; then
  echo $response
  pause 10
  exit 1
fi


response=$(/bin/curl -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/rpc/gpio.write -d '{"pin":2,"val":0}' -k)
if [[ $response != "true" ]]; then
  echo $response
  pause 10
  exit 1
fi


response=$(/bin/curl -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/rpc/gpio.write -d '{"pin":5,"val":1}' -k)
if [[ $response != "true" ]]; then
  echo $response
  pause 10
  exit 1
fi


sleep 2s


response=$(/bin/curl -su :$TOKEN https://dash.vcon.io/api/v3/devices/$DID/rpc/config.set -d '{"config":{"host":{"arch":210,"mode":3},"reboot":500}' -k)
if [[ $response != "true" ]]; then
  echo $response
  pause 10
  exit 1
fi

echo "All commands executed successfully."
pause 10
