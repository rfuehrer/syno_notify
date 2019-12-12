#!/bin/bash

THISDIR=$(dirname $0)
THISDIR=$(dirname $(realpath $0))
CONFIGFILE=$THISDIR/syno_notify.config

######################################
# Read/Init value in config file
# Globals:
#   $CONFIGFILE
# Arguments:
#   $1: variable name
#	$2: default value
#	$3: description of variable
#	$4: output read value to console(log (0/1))
#	$5: initialize config value if not present (0/1) - a later call with <>0 will initialize missing values
# Returns:
#   -
#######################################
read_config_value(){
	local MY_VAR=$1
	local MY_DEFAULT=$2
	local MY_DESCRIPTION=$3
	local MY_OUTPUT=$4
	local MY_INIT_CONFIG=$5
	
	local RET
	RET=""

	if grep -q "^$MY_VAR" $CONFIGFILE
	then
		# string found
		RET=$(cat $CONFIGFILE | grep "^$MY_VAR=" | cut -d= -f2)
		if [ "$RET" == "" ];then
			RET=$MY_DEFAULT
		fi
	else
		RET=$MY_DEFAULT
		if [ "$MY_INIT_CONFIG" != "0" ]; then
			# string not found
			echo "" >>$CONFIGFILE
			echo "; [$MY_VAR] $MY_DESCRIPTION" >>$CONFIGFILE
			echo "$MY_VAR=$MY_DEFAULT" >>$CONFIGFILE
		fi
	fi
	# set dynamic variable name to read content
	eval $MY_VAR=\$RET
}

#######################################
# Read config file an variables
# Globals:
#	$CONFIGFILE
# Arguments:
#   -
# Returns:
#	$IFTTT_KEY
#	$IFTTT_EVENT
#   $VERBOSE
#######################################
read_config() {
	read_config_value "IFTTT_KEY" "" "IFTTT magic key for webhook notifications (value: $)" 0 1
	read_config_value "IFTTT_EVENT" "syno_status" "IFTTT event name for notifications (value: $)" 1 1
	read_config_value "VERBOSE" "0" "Verbose mode (value: 0/1)" 1 1
}

read_config

SYNO_MSG=$1
if [ "$SYNO_MSG" != "" ]; then
	RET=$(curl -f -s -X POST -H "Content-Type: application/json" -d "{\"value1\":\"$SYNO_MSG\"}" https://maker.ifttt.com/trigger/$IFTTT_EVENT/with/key/$IFTTT_KEY > /dev/null && echo "1" || echo "0" )
	if [ $VERBOSE -eq 1 ]; then
		if [ $RET -eq 1 ]; then
			echo "Message sent sucessufully."
		else
			echo "Error sending message..."
		fi
	fi	
else
  echo "No parameter entered. Abort."
fi