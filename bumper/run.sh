#!/bin/sh
set -e

OPTIONS=/data/options.json

ANNOUNCE_IP=$(python3 -c "import json; print(json.load(open('$OPTIONS'))['announce_ip'])")
DEBUG=$(python3 -c "import json; print(str(json.load(open('$OPTIONS'))['debug']).lower())")

if [ -z "$ANNOUNCE_IP" ]; then
    echo "ERROR: set 'announce_ip' to your Home Assistant host IP in the add-on configuration" >&2
    exit 1
fi

CERTS=/data/certs
for f in ca.crt bumper.crt bumper.key; do
    if [ ! -f "$CERTS/$f" ]; then
        echo "ERROR: missing $CERTS/$f - see DOCS.md for how to create the certificates" >&2
        exit 1
    fi
done

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
