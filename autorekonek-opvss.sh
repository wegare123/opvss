#!/bin/bash
#opvss (Wegare)
route2="$(route | grep -i tun0 | head -n1 | awk '{print $8}')" 
route3="$(netstat -plantu | grep -i ss-local | grep -i 1080 | grep -i listen)" 
	if [[ -z $route2 ]]; then
		   printf '\n' | opvss
           exit
    elif [[ -z $route3 ]]; then
		   printf '\n' | opvss
           exit
	fi
