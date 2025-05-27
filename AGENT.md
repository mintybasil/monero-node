# Monero Node Docker Project

## Overview
Docker-based Monero node deployment project that packages the official Monero daemon (monerod) for containerized operation.

## Architecture
- Multi-stage Docker build using Ubuntu 22.04 base images
- Downloads and verifies official Monero CLI binaries (v0.18.3.4)
- Runs as non-root user `monero` with dedicated home directory
- Exposes ports 18080 (P2P) and 18081 (RPC)
- Persistent data storage via volume mount at `/home/monero/.bitmonero`

## Build Commands
- `docker build .` - Build the Docker image
- `docker run -p 18080:18080 -p 18081:18081 -v monero-data:/home/monero/.bitmonero <image>` - Run container

## CI/CD
- GitHub Actions builds on every push
- Publishes to GitHub Container Registry (ghcr.io)
- Manual release workflow accepts version/checksum inputs, updates Dockerfile, creates releases
- Automatic release workflow runs weekly to check for new Monero versions and auto-release
- Automatic tagging with both `latest` and version-specific tags (e.g., `v0.18.3.4`)

## Configuration
- Default monerod args: `--non-interactive --restricted-rpc --rpc-bind-ip=0.0.0.0 --confirm-external-bind --enable-dns-blocklist --out-peers=16`
- Binary checksum verification ensures integrity
- DNS blocklist enabled for security