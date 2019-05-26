#!/usr/bin/env bash

# Feel free to modify the name of the command.
COMMAND_NAME=minit

# Any directory in your $PATH will do instead of /usr/local/bin/
COMMAND=/usr/local/bin/$COMMAND_NAME

# PWD is the current directory
# All the slashes after PWD replace every slash in the directory name with an
# escaped slash using parameter expansion.
# This command modifies configure_cpp.sh so that it knows where the Makefile is.
sed "3 s/^.*$/BASE_DIR=${PWD//\//\\/}/" -i configure_cpp.sh


# Make sure we're not overwriting any other command
if [ -f $COMMAND ] && [ "$(readlink -f $COMMAND)" != "$PWD/configure_cpp.sh" ]; then
	echo "Some other program already has $COMMAND_NAME taken. You must modify the COMMAND_NAME"
	echo "variable at the top of the script or get rid of the other program."
	exit 1
fi

# Have to remove the symbolic link if it already exists so we can replace it.
sudo rm -f $COMMAND

# Create a symbolic link in your
sudo ln -s $PWD/configure_cpp.sh $COMMAND

