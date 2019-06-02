#!/usr/bin/env bash

set -e

minit $*
MF=$1/bin/Makefile

sed -i 's/g++/gcc/g' $MF
sed -i 's/cpp/c/g' $MF
sed -i 's/-std=c++11/-std=c99/g' $MF
