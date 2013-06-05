#!/bin/sh
# OLX
# NOC - Buenos Aires [ Argentina ]
# $File    : olx_scheduler-control.sh
# $Subject : SCHEDULER State Control Script
# $Author  : INFR Team <infrastructure@olx.com>
# $Update  : 2010.08.15 - 11:00 AM


# Variables
TEE_CMD="/usr/bin/tee"
KILL_CMD="/bin/kill"
JAVA_BIN="/usr/local/java/bin/java"
JAVA_OPT=""
SCHEDULER_DIR="/home/httpd/sites/scheduler.olx.com/bin"
SCHEDULER_FILE_NAME=$(find $SCHEDULER_DIR -name 'scheduler-*dependencies.jar')
SCHEDULER_BIN="-Dlog4j.configuration=file:log4j.properties -Xmx256m -jar $SCHEDULER_FILE_NAME -c scheduler.properties -cr scheduler.credentials.properties -p 9191"

LOCK_WARN="0"
LOCK_FILE="/tmp/.scheduler_lock"
LOG_DIR="/var/log/scheduler"
LOG_FILE="scheduler-state.log"


# Begin
if [ $# != 1 ]; then
        echo "Usage: $0 < action :: on | off | status >"
        exit 1;
fi

if [ ! -f $TEE_CMD ]; then
        echo "Error: Command \"$TEE_CMD\" not found."
        exit 1;
fi

if [ ! -f $KILL_CMD ]; then
        echo "Error: Command \"$KILL_CMD\" not found."
        exit 1;
fi

if [ ! -d $SCHEDULER_DIR ]; then
        echo "Error : Directory \"$SCHEDULER_DIR\" not found."
        exit 1;
fi

if [ ! -f $JAVA_BIN ]; then
        echo "Error : Binary \"$JAVA_BIN\" not found."
        exit 1;
fi


if [ ! -d $LOG_DIR ]; then
        echo "Error: Directory \"$LOG_DIR\" not found."
        exit 1;
fi

if [ ! -f $LOG_DIR/$LOG_FILE ]; then
        touch $LOG_DIR/$LOG_FILE
fi

LOG="$LOG_DIR/$LOG_FILE"

if [  -f $LOCK_FILE  ]; then
        SCHEDULER_PID=`cat $LOCK_FILE`
        ACTIVE=`ps ax | awk '{ print $1 }' | grep $SCHEDULER_PID | wc -l`
        if [ $ACTIVE -ne "1" ]; then
                RECHECK=`ps ax | grep "scheduler-.*-jar-with-dependencies.jar" | grep -v grep | wc -l`
                if [ $RECHECK -eq "1" ]; then
                        SCHEDULER_PID=`ps ax | grep "scheduler-.*-jar-with-dependencies.jar" | grep -v grep | awk '{ print $1 }'`
                        echo "$SCHEDULER_PID" > $LOCK_FILE
                        STATUS="1"
                else
                        STATUS="0"
                fi
        else
                STATUS="1"
        fi
else
        ACTIVE=`ps ax | grep "scheduler-.*-jar-with-dependencies.jar" | grep -v grep | wc -l`
        if [ $ACTIVE -ne "1" ]; then
                STATUS="0"
        else
                SCHEDULER_PID=`ps ax | grep "scheduler-.*-jar-with-dependencies.jar" | grep -v grep | awk '{ print $1 }'`
                STATUS="1"
                LOCK_WARN="1"
                echo "$SCHEDULER_PID" > $LOCK_FILE
        fi
fi

echo ""                                                                                     | $TEE_CMD -a $LOG
echo "--------------------------------------------------------------"                       | $TEE_CMD -a $LOG
echo ""                                                                                     | $TEE_CMD -a $LOG
echo " **** OLX QA :: Scheduler Control State Process ****"                                        | $TEE_CMD -a $LOG
echo ""                                                                                     | $TEE_CMD -a $LOG
TIME_INIT=`date +%r`
DATE_INIT=`date +%x`
echo " ++ Start Time : $TIME_INIT - $DATE_INIT"                                             | $TEE_CMD -a $LOG
echo ""                                                                                     | $TEE_CMD -a $LOG


OPTION=$1
case $OPTION in
        on)
                if [ $STATUS -eq "1" ]; then
                        echo "  + Scheduler : Process already running PID \"$SCHEDULER_PID\""         | $TEE_CMD -a $LOG
                else
                        echo "  + Scheduler : Process not running, launching Scheduler."                | $TEE_CMD -a $LOG
                        cd $SCHEDULER_DIR
                        $JAVA_BIN $JAVA_OPT $SCHEDULER_BIN > /dev/null 2>&1 &
                        echo "$!" > $LOCK_FILE
                fi
                ;;
        off)
                if [ $STATUS -eq "1" ]; then
                        echo "  + Scheduler : Process running PID \"$SCHEDULER_PID\", stopping Scheduler." | $TEE_CMD -a $LOG
                        $KILL_CMD -9 $SCHEDULER_PID
                else
                        echo "  + Scheduler : Process not running."                                | $TEE_CMD -a $LOG
                fi
                ;;
        status)
                if [ $STATUS -eq "1" ]; then
                        echo "  + Scheduler : Process running with PID \"$SCHEDULER_PID\"."           | $TEE_CMD -a $LOG
                        if [ $LOCK_WARN -eq "1" ]; then
                                echo "  !! Warning : No LOCK file found."                       | $TEE_CMD -a $LOG
                        fi
                else
                        echo "  + Scheduler : Process not running."                                | $TEE_CMD -a $LOG
                fi
                ;;
        *)
                echo "  + Scheduler : Action should be [ on | off | status ]"                  | $TEE_CMD -a $LOG
                ;;
esac

echo ""                                                                                     | $TEE_CMD -a $LOG
TIME_END=`date +%r`
DATE_END=`date +%x`
echo " ++ End Time   : $TIME_END - $DATE_END"                                               | $TEE_CMD -a $LOG
echo ""                                                                                     | $TEE_CMD -a $LOG
echo "--------------------------------------------------------------"                       | $TEE_CMD -a $LOG
echo ""                                                                                     | $TEE_CMD -a $LOG


exit 0

# End