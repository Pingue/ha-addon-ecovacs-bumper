# Bumper

Runs [bmartin5692/bumper](https://github.com/bmartin5692/bumper) inside Home Assistant.
It includes its own MQTT broker, so it does **not** use the Mosquitto add-on.

## Setup

1. Create the certificates (see `docs/Create_Certs.md` in the bumper repo). The add-on expects
   `ca.crt`, `bumper.crt` and `bumper.key` in `/data/certs` inside the add-on's persistent data.
   The robots must trust `ca.crt`.
2. Set `announce_ip` to the IP address of your Home Assistant host.
3. Start the add-on.

## Ports

443, 8007, 8883, 5223 are mapped to the host. Anything else already using these ports
on the HA host (for example another reverse proxy add-on) will conflict.

## Options

- `announce_ip`: IP the robots should connect to. Required.
- `debug`: verbose logging.
