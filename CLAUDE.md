# ha-addon-ecovacs-bumper

## Overview

Packages [bmartin5692/bumper](https://github.com/bmartin5692/bumper) — a local
replacement for the Ecovacs cloud (config server, MQTT broker, XMPP server) —
as a Home Assistant add-on, so Ecovacs robots and the app can be used fully
locally instead of phoning home.

This is a Home Assistant add-on **repository**: add `repository.yaml`'s
parent URL as a repository in HA's Add-on Store, and the `bumper/` folder
installs as the "Bumper" add-on.

Bumper requires DNS interception: the robot and app resolve Ecovacs' real
hostnames (`*.ecovacs.com`, `*.ecouser.net`, `*.ecovacs.net`), which must be
pointed at this add-on's host instead (e.g. via Pi-hole/AdGuard). That setup
lives outside this repo, on the user's network.

## Layout

- `repository.yaml` - marks this repo as an HA add-on repository.
- `bumper/` - the add-on itself.
  - `config.yaml` - HA add-on manifest (ports, options, arch, version).
  - `Dockerfile` - builds on top of `bmartin5692/bumper`, adds nginx and a
    from-source cert generator (the upstream binaries are x86-only).
  - `run.sh` - entrypoint: reads add-on options, generates certs on first
    start, starts nginx + bumper.
  - `nginx.conf` - SNI-based TCP proxy for port 443. Newer robot/app
    firmware connects to 443 expecting MQTT, not HTTPS; bots with no SNI
    default to MQTT too. This routes accordingly, mirroring upstream
    bumper's own docker-compose/nginx example.
  - `create_certs.go`, `Bumper_SAN.txt` - vendored from upstream bumper, used
    to build the cert generator for whatever architecture the add-on runs on.
  - `CHANGELOG.md` - see below.

## Versioning

**Every change to `bumper/config.yaml`'s `version` must come with a
`bumper/CHANGELOG.md` entry for that version.** Home Assistant reads this
changelog and shows it to the user in the Supervisor UI when an update is
available - it's the only place users see what changed, since this isn't
published anywhere else. A version bump with no changelog entry is an
incomplete change.
