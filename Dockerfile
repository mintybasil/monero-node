FROM ubuntu:22.04 AS builder

ENV VERSION=0.18.5.0
ENV CHECKSUM=166ad93036f95f5abeba24c8670061be022c9238dba2e6a7587611a1d759e294

WORKDIR /root

RUN set -ex && apt-get update && apt-get install --no-install-recommends --yes curl ca-certificates bzip2

RUN curl https://dlsrc.getmonero.org/cli/monero-linux-x64-v$VERSION.tar.bz2 -O
RUN echo "$CHECKSUM monero-linux-x64-v$VERSION.tar.bz2" | sha256sum -c -
RUN tar -xvf monero-linux-x64-v$VERSION.tar.bz2
RUN mv ./monero-x86_64-linux-gnu-v$VERSION/monerod .

FROM ubuntu:22.04

RUN adduser --system --group --disabled-password monero && mkdir -p /home/monero/.bitmonero && chown -R monero:monero /home/monero/.bitmonero
USER monero
WORKDIR /home/monero

COPY --chown=monero:monero --from=builder /root/monerod /home/monero/monerod

VOLUME /home/monero/.bitmonero

EXPOSE 18080 18081

ENTRYPOINT ["./monerod"]
CMD ["--non-interactive", "--restricted-rpc", "--rpc-bind-ip=0.0.0.0", "--confirm-external-bind", "--enable-dns-blocklist", "--out-peers=16"]
