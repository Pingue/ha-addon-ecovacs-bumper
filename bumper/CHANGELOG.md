# Changelog

## 0.2.0

- Added an nginx stream proxy in front of port 443 that routes by TLS SNI
  between bumper's HTTPS confserver and its MQTT broker. Newer robot/app
  firmware connects to 443 expecting MQTT, not HTTPS, and bots connecting
  directly by IP (no SNI) default to MQTT too - without this, those
  connections completed a TLS handshake but never worked.
- Added aarch64 and armv7 to the supported architectures.
- Certificates are now generated on first start (stored in
  `/share/bumper/certs`) and built from source for the add-on's own
  architecture, instead of relying on the upstream project's x86-only
  binaries.
- The add-on now logs its version and the image build date as the first
  line on start.

## 0.1.0

- Initial release: packages `bmartin5692/bumper` as a Home Assistant add-on.
