#!/bin/sh
#
# thin – Startup script for thin

# chkconfig: 2345 99 00
# description: historical-managerator-thin
# processname: historical-managerator-thin
# pidfile: /tmp/historical-managerator-thin.pid

# Source function library
. /etc/rc.d/init.d/functions

PIDFILE="/tmp/historical-managerator-thin.pid"
THIN_DIRECTORY="/opt/gnip/search_demo/current"
RETVAL=0

start() {
  if [ -f $PIDFILE ]; then
    echo 'process is already running'
    RETVAL=1
  else
    sh -c "cd $THIN_DIRECTORY && /usr/local/bin/bundle exec thin -R streamer.ru -p 3001 -d -P $PIDFILE -g wheel -u gnip start"
    RETVAL=$?
  fi
}

stop() {
  if [ -f $PIDFILE ]; then
    killproc -p $PIDFILE
    RETVAL=$?
    rm -f $PIDFILE
  fi
}

case "$1" in
	start)
		start
	;;
	stop)
		stop
	;;
	restart)
		stop
		start
	;;
	status)
    [ -f $PIDFILE ]
	;;
	*)
		echo $"Usage: $0 {start|stop|restart|status}"
		RETVAL=1
esac

exit $RETVAL
