# Build the cert generator for the host's architecture (the upstream binaries are x86 only)
FROM golang:1.22-alpine AS certs
COPY create_certs/create_certs.go /src/create_certs.go
RUN cd /src && CGO_ENABLED=0 go build -o /create_certs create_certs.go

FROM bmartin5692/bumper:latest

RUN apk add --no-cache nginx nginx-mod-stream

COPY --from=certs /create_certs /bumper/create_certs/create_certs
COPY create_certs/Bumper_SAN.txt /bumper/create_certs/Bumper_SAN.txt
COPY nginx.conf /etc/nginx/nginx.conf
COPY config.yaml /addon-config.yaml
COPY run.sh /run.sh
RUN chmod +x /run.sh && date -u +%Y-%m-%dT%H:%M:%SZ > /build-date

ENTRYPOINT ["/run.sh"]
