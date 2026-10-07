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
    /bumper/create_certs/create_certs -out "$CERTS" -inSAN /bumper/create_certs/Bumper_SAN.txt
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

# nginx routes host port 443 (mapped to internal 9443) between bumper's HTTPS
# confserver and its MQTT broker by SNI, since newer robots/app connect to 443
# expecting MQTT. See nginx.conf. Runs in the background; bumper is the
# foreground process, so the container exits if bumper dies.
nginx -g 'daemon off;' &

cd /bumper
exec python3 -m bumper
