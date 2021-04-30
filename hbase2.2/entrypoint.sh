#!/usr/bin/env bash
set -x
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x


export HBASE_HOME="/opt/hbase"
export JAVA_HOME="${JAVA_HOME:-/usr}"

echo "================================================================================"
echo "                              HBase Docker Container"
echo "================================================================================"
echo
# shell breaks and doesn't run zookeeper without this
mkdir -pv "$HBASE_HOME/logs"

start_zookeeper(){
    echo
    echo "Starting Zookeeper..."
    "$HBASE_HOME/bin/hbase" zookeeper &>"$HBASE_HOME/logs/zookeeper.log" &
    echo
}

start_master(){
    echo "Starting HBase Master..."
    "$HBASE_HOME/bin/hbase-daemon.sh" start master
    echo
}

start_regionserver(){
    echo "Starting HBase RegionServer..."
    # HBase versions < 1.0 fail to start RegionServer without SSH being installed
    if [ "$(echo /hbase-* | sed 's,/hbase-,,' | cut -c 1)" = 0 ]; then
        "$HBASE_HOME/bin/local-regionservers.sh" start 1
    else
        "$HBASE_HOME/bin/hbase-daemon.sh" start regionserver
    fi
    echo
}

start_stargate(){
    # kill any pre-existing rest instances before starting new ones
    pgrep -f proc_rest && pkill -9 -f proc_rest
    echo "Starting HBase Stargate Rest API server..."
    "$HBASE_HOME/bin/hbase-daemon.sh" start rest
    echo
}

start_thrift(){
    # kill any pre-existing thrift instances before starting new ones
    pgrep -f proc_thrift && pkill -9 -f proc_thrift
    echo "Starting HBase Thrift API server..."
    "$HBASE_HOME/bin/hbase-daemon.sh" start thrift
    echo
}

start_hbase_shell(){
    echo "
Example Usage:

create 'table1', 'columnfamily1'

put 'table1', 'row1', 'columnfamily1:column1', 'value1'

get 'table1', 'row1'


Now starting HBase Shell...
"
    "$HBASE_HOME/bin/hbase" shell
}

trap_func(){
    echo -e "\n\nShutting down HBase:"
    "$HBASE_HOME/bin/hbase-daemon.sh" stop rest || :
    "$HBASE_HOME/bin/hbase-daemon.sh" stop thrift || :
    "$HBASE_HOME/bin/local-regionservers.sh" stop 1 || :
    # let's not confuse users with superficial errors in the Apache HBase scripts
    "$HBASE_HOME/bin/stop-hbase.sh" |
        grep -v -e "ssh: command not found" \
                -e "kill: you need to specify whom to kill" \
                -e "kill: can't kill pid .*: No such process"
    sleep 2
    pgrep -fla org.apache.hadoop.hbase |
        grep -vi org.apache.hadoop.hbase.zookeeper |
            awk '{print $1}' |
                xargs kill 2>/dev/null || :
    sleep 3
    pkill -f org.apache.hadoop.hbase.zookeeper 2>/dev/null || :
    sleep 2
}
trap trap_func INT QUIT TRAP ABRT TERM EXIT

if [ -n "$*" ]; then
    if [ "$1" = master ] || [ "$1" = m ]; then
        start_master
        tail -f /dev/null "$HBASE_HOME/logs/"* &
    elif [ "$1" = regionserver ] || [ "$1" = rs ]; then
        start_regionserver
        tail -f /dev/null "$HBASE_HOME/logs/"* &
    elif [ "$1" = rest ] || [ "$1" = stargate ]; then
        start_stargate
        tail -f /dev/null "$HBASE_HOME/logs/"* &
    elif [ "$1" = thrift ]; then
        start_thrift
        tail -f /dev/null "$HBASE_HOME/logs/"* &
    elif [ "$1" = shell ]; then
        "$HBASE_HOME/bin/hbase" shell
    elif [ "$1" = bash ]; then
        bash
    else
        echo "usage:  must specify one of: master, regionserver, thrift, rest, shell, bash"
    fi
else
    sed -i 's/zookeeper:2181/localhost:2181/' "$HBASE_HOME/conf/hbase-site.xml"
    start_zookeeper
    start_master
    start_regionserver
    start_stargate
    start_thrift
    if [ -t 0 ]; then
        start_hbase_shell
    else
        echo "
    Running non-interactively, will not open HBase shell

    For HBase shell start this image with 'docker run -t -i' switches
    "
        tail -f /dev/null "$HBASE_HOME/logs/"* &
        # this shuts down from Control-C but exits prematurely, even when +euo pipefail and doesn't shut down HBase
        # so I rely on the sig trap handler above
    fi
fi
wait || :
