#!/bin/sh
set -e

OPTIONS=/data/options.json

ANNOUNCE_IP=$(python3 -c "import json; print(json.load(open('$OPTIONS'))['announce_ip'])")
DEBUG=$(python3 -c "import json; print(str(json.load(open('$OPTIONS'))['debug']).lower())")

if [ -z "$ANNOUNCE_IP" ]; then
    echo "ERROR: set 'announce_ip' to your Home Assistant host IP in the add-on configuration" >&2
    exit 1
fi

CERTS=/share/bumper/certs
if [ ! -f "$CERTS/bumper.crt" ] || [ ! -f "$CERTS/bumper.key" ] || [ ! -f "$CERTS/ca.crt" ]; then
    echo "Generating certificates in $CERTS (first start)"
    mkdir -p "$CERTS"
    /bumper/create_certs/create_certs_linux -out "$CERTS"
fi

export BUMPER_LISTEN=0.0.0.0
export BUMPER_ANNOUNCE_IP="$ANNOUNCE_IP"
export BUMPER_DATA=/data
export BUMPER_LOGS=/data/logs
export BUMPER_CERTS="$CERTS"
export BUMPER_CA="$CERTS/ca.crt"
export BUMPER_CERT="$CERTS/bumper.crt"
export BUMPER_KEY="$CERTS/bumper.key"
export BUMPER_DEBUG="$DEBUG"
export LOG_TO_STDOUT=true

cd /bumper
exec python3 -m bumper
