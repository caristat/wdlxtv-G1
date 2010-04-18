#!/bin/sh

if [ -f /tmp/emergency.flash ]; then
	exit 0
fi

case "$1" in
start)
	if [ -e /tmp/net.config ]; then
	  . /tmp/net.config
	else
	  if [ -e /conf/net.config ]; then
	    dos2unix /conf/net.config
	    . /conf/net.config
	  fi
	fi

	if [ "$LOAD" != "" ]; then
	  cat /tmp/net.config /conf/net.config | egrep '^LOAD=' | cut -d'=' -f2 > /tmp/LOADS
	  for m in `cat /tmp/LOADS` ; do
	    modprobe $m
	    [ $? != 0 ] && insmod $m
	  done
	  rm /tmp/LOADS
	fi

	if [ "$SUPPRESS_OTHERS" != "yes" ]; then
		for a in asix dm9601 kaweth mcs7830 pegasus rtl8150 cdc_ether \
			catc cdc_subset net1080 plusb rndis_host gl620a; do
		  modprobe $a
		done
	fi
	;;
esac
