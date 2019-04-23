#!/usr/bin/env bash

BASE_DIR=/home/joseph/dev/cpp_init

# The $# contains the number of arguments passed into the script
if [ $# -eq 0 ]; then
	echo ""
	echo "USAGE: $(basename $0) project_name output_file_name"
	echo ""
	exit 1
fi

# Make a directory with the project name you provided
mkdir -p "$1"

cd $1

# Make all the inner directories
mkdir -p "bin"
mkdir -p "obj"
mkdir -p "includes"
mkdir -p "src"
mkdir -p "libs"

cd bin

# Copy the Makefile to the bin directory
cp $BASE_DIR/Makefile .

# Replace the first line in the Makefile with your project name
sed "1 s/^.*$/PRODUCT := $2/" -i Makefile
