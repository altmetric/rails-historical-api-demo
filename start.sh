#!/bin/bash

if [ -z "$GNIP_ACCOUNT" ]; then
	echo -n 'Account: '
	read GNIP_ACCOUNT
fi
if [ -z "$GNIP_USERNAME" ]; then
	echo -n 'Username: '
	read GNIP_USERNAME
fi
if [ -z "$GNIP_PASSWORD"]; then
	echo -n 'Password: '
	read -s GNIP_PASSWORD
fi

GNIP_ACCOUNT=$GNIP_ACCOUNT GNIP_USERNAME=$GNIP_USERNAME GNIP_PASSWORD=$GNIP_PASSWORD rails s
