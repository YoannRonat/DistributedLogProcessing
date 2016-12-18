#! /bin/bash

scp -i ~/.ssh/xnet logDl.sh xnet@server-1:
scp -i ~/.ssh/xnet logDl.sh xnet@server-2:
scp -i ~/.ssh/xnet logDl.sh xnet@server-3:

pas=33
echo $pas
for i in $(seq 1576948 101 1578000)
do
	#ssh -i ~/.ssh/xnet xnet@server-1 "expr "$i" + "$pas" - 1"  
    ssh -i ~/.ssh/xnet xnet@server-1 "./logDl.sh "$i" `expr "$i" + "$pas" - 1`" & \
    ssh -i ~/.ssh/xnet xnet@server-2 "./logDl.sh `expr "$i" + "$pas"` `expr "$i" + 2 \* "$pas" - 1`" & \
    ssh -i ~/.ssh/xnet xnet@server-3 "./logDl.sh `expr "$i" + 2 \* "$pas"` `expr "$i" + 3 \* "$pas" - 1`" & wait
done

