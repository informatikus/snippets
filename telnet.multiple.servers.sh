#!/bin/bash

## mainly useful in situations where you dont have access to a nmap installation

cat hosts | (
  TCP_TIMEOUT=3
  while read host port; do
    (CURPID=$BASHPID;
    (sleep $TCP_TIMEOUT;kill $CURPID) &
    exec 3<> /dev/tcp/$host/$port
    ) 2>/dev/null
    case $? in
    0)
      echo $host $port is open;;
    1)
      echo $host $port is closed;;
    143) # killed by SIGTERM
       echo $host $port timeouted;;
     esac
  done
  ) 2>/dev/null # avoid bash message "Terminated ..."
