#!/bin/sh

domain="..." # FIXME
token="..." # FIXME
ipv4=$(curl --silent --ipv4 https://api4.ipify.org)
ipv6=$(curl --silent --ipv6 https://api6.ipify.org)

curl -G -o /mnt/data/duckdns.log \
    --data-urlencode "domains=$domain" \
    --data-urlencode "token=$token" \
    --data-urlencode "ip=$ipv4" \
    --data-urlencode "ipv6=$ipv6" \
    https://www.duckdns.org/update
