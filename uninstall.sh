#!/usr/bin/env bash

set -e
CPP_COMMAND_NAME="$(grep install.sh -e "^CPP_COMMAND_NAME=" | sed "s/.*CPP_COMMAND_NAME=//g")"
C_COMMAND_NAME="$(grep install.sh -e "^C_COMMAND_NAME=" | sed "s/.*C_COMMAND_NAME=//g")"

CPP_COMMAND="$(which $CPP_COMMAND_NAME)"
C_COMMAND="$(which $C_COMMAND_NAME)"

sed "s/^BASE_DIR=.*/BASE_DIR=/g" -i minit.sh

if [ -f "$CPP_COMMAND" ] && [ "$(readlink -f $CPP_COMMAND)" = "$PWD/minit.sh" ]; then
	sudo rm -rf $CPP_COMMAND
fi

if [ -f "$C_COMMAND" ] && [ "$(readlink -f $C_COMMAND)" = "$PWD/minit-c.sh" ]; then
	sudo rm -rf $C_COMMAND
fi

echo "Uninstall successful!"
