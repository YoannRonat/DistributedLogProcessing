#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"

if [[ $# -ne 2 ]]; then
	echo "usage: ./kill.sh [machine id] [process name]" >&2
	exit
fi

################# Function definition ###################

kill_process () {
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo systemctl stop "$2".service > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "ps ax | grep -E '"$2"' | awk -F ' ' '{print \$1}' | xargs sudo kill -9 > /dev/null"
}

kill_process "$1" "$2"