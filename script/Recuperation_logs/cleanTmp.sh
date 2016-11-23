#!/bin/bash

# Script qui nettoie les dossiers de log sur chaque machine

ssh -i ~/.ssh/xnet xnet@server-1 "rm -r /tmp/logs_tf/" &
ssh -i ~/.ssh/xnet xnet@server-2 "rm -r /tmp/logs_tf/" &
ssh -i ~/.ssh/xnet xnet@server-3 "rm -r /tmp/logs_tf/" &