#!/bin/bash
#change ip
limit=50

if ! pgrep tor > /dev/null; then
echo "tor not started"
exit
fi

for i in $(seq 1 $limit)
do
  sudo killall -HUP tor
  printf "%s%i%s%s\n" "request:" $i " ip:" "$(curl -s --socks5 127.0.0.1:9050 http://checkip.amazonaws.com/)"
  curl -s --socks5 127.0.0.1:9050 $1 > /dev/null
done
