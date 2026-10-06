# Bumper

Runs [bmartin5692/bumper](https://github.com/bmartin5692/bumper) inside Home Assistant.
It includes its own MQTT broker, so it does **not** use the Mosquitto add-on.

## Setup

1. On first start the add-on generates certificates in `/share/bumper/certs`
   (`ca.crt`, `bumper.crt`, `bumper.key`). They are kept on restart.
2. To use the app on a phone, install `ca.crt` on the device (it is reachable via the Samba share at `share/bumper/certs`).
   Robots must trust the same CA. Do not delete the certs once devices are set up, or they will need to be re-trusted.
3. Set `announce_ip` to the IP address of your Home Assistant host.
4. Start the add-on.

## Ports

443, 8007, 8883, 5223 are mapped to the host. Anything else already using these ports
on the HA host (for example another reverse proxy add-on) will conflict.

## Options

- `announce_ip`: IP the robots should connect to. Required.
- `debug`: verbose logging.
