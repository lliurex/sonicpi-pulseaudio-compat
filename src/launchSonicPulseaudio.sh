#/bin/bash
#Copyright 2022 Lliurex Team
#GPL-3 License https://www.gnu.org/licenses/gpl-3.0.html

JACKPARMS=$@
JACKPID=""
if [ $# -eq 0 ]
then
	JACKPARMS="-R -d alsa"
fi

if [[ -z $(ps -e | grep jackd) ]]
then
	jackd $JACKPARMS &
	JACKPID=$!
	sleep 1
	pactl load-module module-jack-sink
	pactl load-module module-jack-source
	pacmd set-default-sink jack_out
	pacmd set-default-source jack_in
fi

sonic-pi

[[ $JACKPID -ne "" ]] && [[ ! -z $(ps -e | grep jackd | grep $JACKPID) ]] &&  kill -sTERM $JACKPID
exit 0
