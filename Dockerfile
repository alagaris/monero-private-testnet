FROM phusion/baseimage:master as build

WORKDIR /build
RUN apt-get update && apt-get install -y bzip2
RUN curl -L https://downloads.getmonero.org/cli/linux64 > monero.tar.bz2
RUN tar jxvf monero.tar.bz2 --strip-components=1 -C /build/

FROM phusion/baseimage:master

WORKDIR /usr/local/bin
COPY --from=build /build/monerod ./
COPY --from=build /build/monero-wallet-rpc ./
COPY wallets/01_seed.txt /root/
COPY wallets/02_seed.txt /root/
COPY wallets/03_seed.txt /root/
ADD entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 18081 18082 18083 28081 38081 48081
CMD ["/usr/local/bin/entrypoint.sh"]
