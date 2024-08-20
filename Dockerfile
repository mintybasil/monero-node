FROM ubuntu:22.04 as builder

ENV VERSION=0.18.3.3
ENV CHECKSUM=47c7e6b4b88a57205800a2538065a7874174cd087eedc2526bee1ebcce0cc5e3

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
