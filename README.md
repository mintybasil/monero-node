# monero-node

Dockerized Monero node with official binaries and security defaults.

## Features

- Multi-stage Docker build using Ubuntu 22.04
- Downloads and verifies official Monero CLI binaries (v0.18.3.4)
- Runs as non-root user for security
- Binary integrity verified via checksum validation
- DNS blocklist enabled by default
- Restricted RPC enabled
- Persistent data storage via volume mounts

## Quick Start

### Docker
```bash
docker build -t monero-node .
docker run -p 18080:18080 -p 18081:18081 -v monero-data:/home/monero/.bitmonero monero-node
```

### Docker Compose
```yaml
version: '3.8'
services:
  monero-node:
    build: .
    ports:
      - "18080:18080"
      - "18081:18081"
    volumes:
      - monero-data:/home/monero/.bitmonero

volumes:
  monero-data:
```

## Ports

- **18080**: P2P network port
- **18081**: RPC interface port

## Configuration

Default arguments:
- `--non-interactive`
- `--restricted-rpc`
- `--rpc-bind-ip=0.0.0.0`
- `--confirm-external-bind`
- `--enable-dns-blocklist`
- `--out-peers=16`

