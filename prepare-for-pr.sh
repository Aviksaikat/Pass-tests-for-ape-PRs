#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m' 
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if [ "$#" -ne 1 ];
then
	echo -e "${RED}[!] Usage: ${0} path -f(optional: set it to install dependencies)${NC}"
	exit
fi

# Check if mypy is installed
if ! [ -x "$(command -v mypy)" ];
then
	echo -e "${RED}mypy is not installed${NC}"
	if [[ "$2" != "-f" ]];
	then
		exit 1
	fi
fi

# Check if black is installed
if ! [ -x "$(command -v black)" ];
then
	echo -e "${RED}black is not installed${NC}"
 	if [[ "$2" != "-f" ]];
	then
		exit 2
	fi
fi

# Check if -f flag is passed
if [[ "$2" == "-f" ]];
then
	echo -e "${YELLOW}If black or mypy is missing they will be installed.${NC}"
	# Check if pip or pip3 is available and install packages
	if command -v pip &>/dev/null;
	then
		pip install mypy black
	elif command -v pip3 &>/dev/null;
		then
		pip3 install mypy black
	else
		echo -e "${RED}Error: Neither pip nor pip3 found. Unable to install packages.${NC}"
		exit 3
	fi
fi


dir=$1

# go to the dir
cd $dir
# track the changed files & format it using black
git status | grep modified | awk '{print $2}'| while read file; do echo "Files modified->$file"; black $file; done
# track newly created files
git status | grep "new file:" | awk '{print $3}'| while read file; do echo "Files created->$file"; black $file; done
# run mypy
mypy $dir

echo -e "${GREEN}Done!${NC}"
