#!/usr/bin/env /usr/bin/bash

monerod --testnet --p2p-bind-port 28080 --rpc-bind-ip 0.0.0.0 --confirm-external-bind --rpc-bind-port 28081 --zmq-rpc-bind-port 28082 --no-igd --hide-my-port --log-level 1 --data-dir /testnet/node_01 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:38080 --add-exclusive-node 127.0.0.1:48080 --fixed-difficulty 100 --detach
monerod --testnet --p2p-bind-port 38080 --rpc-bind-ip 0.0.0.0 --confirm-external-bind --rpc-bind-port 38081 --zmq-rpc-bind-port 38082 --no-igd --hide-my-port --log-level 1 --data-dir /testnet/node_02 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:48080 --fixed-difficulty 100 --detach
monerod --testnet --p2p-bind-port 48080 --rpc-bind-ip 0.0.0.0 --confirm-external-bind --rpc-bind-port 48081 --zmq-rpc-bind-port 48082 --no-igd --hide-my-port --log-level 1 --data-dir /testnet/node_03 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:38080 --fixed-difficulty 100 --detach

seed1=$(</root/01_seed.txt)
seed2=$(</root/02_seed.txt)
seed3=$(</root/03_seed.txt)

if [ ! -f "/testnet/wallet_01.bin" ]; then
  monero-wallet-rpc --testnet --daemon-port 28081 --trusted-daemon --wallet-dir /testnet/ --log-file /testnet/wallet_01.log --rpc-bind-port 18081 --disable-rpc-login --rpc-bind-ip 0.0.0.0 --confirm-external-bind --detach
  sleep 3
  curl -X POST http://localhost:18081/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"restore_deterministic_wallet","params":{"filename":"wallet_01.bin","password":"","seed":"'"$seed1"'","restore_height":0, "language":"English","seed_offset":"","autosave_current":true}}' -H 'Content-Type: application/json'
else
  monero-wallet-rpc --testnet --daemon-port 28081 --trusted-daemon --wallet-file /testnet/wallet_01.bin --password "" --log-file /testnet/wallet_01.log --rpc-bind-port 18081 --disable-rpc-login --rpc-bind-ip 0.0.0.0 --confirm-external-bind --detach

fi

if [ ! -f "/testnet/wallet_02.bin" ]; then
  monero-wallet-rpc --testnet --daemon-port 38081 --trusted-daemon --wallet-dir /testnet/ --log-file /testnet/wallet_02.log --rpc-bind-port 18082 --disable-rpc-login --rpc-bind-ip 0.0.0.0 --confirm-external-bind --detach
  sleep 3
  curl -X POST http://localhost:18082/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"restore_deterministic_wallet","params":{"filename":"wallet_02.bin","password":"","seed":"'"$seed2"'","restore_height":0, "language":"English","seed_offset":"","autosave_current":true}}' -H 'Content-Type: application/json'
else
  monero-wallet-rpc --testnet --daemon-port 38081 --trusted-daemon --wallet-file /testnet/wallet_02.bin --password "" --log-file /testnet/wallet_02.log --rpc-bind-port 18082 --disable-rpc-login --rpc-bind-ip 0.0.0.0 --confirm-external-bind --detach
fi

if [ ! -f "/testnet/wallet_03.bin" ]; then
  monero-wallet-rpc --testnet --daemon-port 48081 --trusted-daemon --wallet-dir /testnet/ --log-file /testnet/wallet_03.log --rpc-bind-port 18083 --disable-rpc-login --rpc-bind-ip 0.0.0.0 --confirm-external-bind --detach
  sleep 3
  curl -X POST http://localhost:18083/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"restore_deterministic_wallet","params":{"filename":"wallet_03.bin","password":"","seed":"'"$seed3"'","restore_height":0, "language":"English","seed_offset":"","autosave_current":true}}' -H 'Content-Type: application/json'  
else
  monero-wallet-rpc --testnet --daemon-port 48081 --trusted-daemon --wallet-file /testnet/wallet_03.bin --password "" --log-file /testnet/wallet_03.log --rpc-bind-port 18083 --disable-rpc-login --rpc-bind-ip 0.0.0.0 --confirm-external-bind --detach
fi

sleep 3
curl -X POST http://localhost:18081/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"start_mining","params":{"threads_count":1}}' -H 'Content-Type: application/json'
tail -f /testnet/wallet_02.log -f /testnet/wallet_03.log