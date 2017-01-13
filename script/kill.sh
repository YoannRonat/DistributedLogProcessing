#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"

if [[ $# -ne 2 ]]; then
	echo "usage: ./kill.sh [machine id] [process name]" >&2
	exit
fi

################# Function definition ###################

kill_process () {
	# These variables allow us to use ssh or not depending on the server
	cmd="ssh -i  ~/.ssh/xnet xnet@server-$1 \""
	end_cmd="\""
	num="$1"

	eval ""$cmd"sudo systemctl stop "$2".service"$end_cmd""
}

kill_process "$1" "$2"