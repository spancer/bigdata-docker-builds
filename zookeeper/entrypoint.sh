#!/usr/bin/env bash
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

# 3.3 fails to start the first time with this dir
mkdir -p /tmp/zookeeper
# zookeeper.out will be written to $PWD
cd /tmp
zkServer.sh start
sleep 2
if [ -t 0 ]; then
    zkCli.sh
    echo -e "\n\nZooKeeper shell exited\n"
else
    echo "
Running non-interactively, will not open ZooKeeper shell

For ZooKeeper shell start this image with 'docker run -t -i' switches
"
fi
echo -e "\nWill tail log now to keep this container alive until killed...\n\n"
sleep 30
tail -f /dev/null zookeeper.out &
wait || :
