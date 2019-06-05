#!/usr/bin/env bash

set -e

# Feel free to modify the name of the command.
CPP_COMMAND_NAME=minit
C_COMMAND_NAME=minit-c

# Any directory in your $PATH will do instead of /usr/local/bin/
CPP_COMMAND=/usr/local/bin/$CPP_COMMAND_NAME
C_COMMAND=/usr/local/bin/$C_COMMAND_NAME

# PWD is the current directory
# All the slashes after PWD replace every slash in the directory name with an
# escaped slash using parameter expansion.
# This command modifies minit.sh so that it knows where the Makefile is.
sed "s/^BASE_DIR=$/BASE_DIR=${PWD//\//\\/}/g" -i minit.sh

# Make sure we're not overwriting any other command
if [ -f $CPP_COMMAND ] && [ "$(readlink -f $CPP_COMMAND)" != "$PWD/minit.sh" ]; then
	echo "Some other program already has $CPP_COMMAND_NAME taken. You must modify the CPP_COMMAND_NAME"
	echo "variable at the top of the script or get rid of the other program."
	exit 1
fi

if [ -f $C_COMMAND ] && [ "$(readlink -f $C_COMMAND)" != "$PWD/minit-c.sh" ]; then
	echo "Some other program already has $C_COMMAND_NAME taken. You must modify the CPP_COMMAND_NAME"
	echo "variable at the top of the script or get rid of the other program."
	exit 1
fi

# Have to remove the symbolic link if it already exists so we can replace it.
sudo rm -f $CPP_COMMAND
sudo rm -f $C_COMMAND

# Create a symbolic link in your PATH variable
sudo ln -s $PWD/minit.sh $CPP_COMMAND
sudo ln -s $PWD/minit-c.sh $C_COMMAND

sudo chmod 755 $PWD/minit.sh
sudo chmod 755 $PWD/minit-c.sh
