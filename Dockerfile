FROM ubuntu:22.04 AS builder

ENV VERSION=0.18.4.2
ENV CHECKSUM=41d023f2357244ea43ee0a74796f5705ce75ce7373a5865d4959fefa13ecab06

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
