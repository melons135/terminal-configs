#!/bin/bash

# Get location of folder
Location=$(find / -type d -name terminal-configs)

# If there are multiple locations ask user for input for correct one
if (( $($Locations | wc -l) > 1 ))
then
	echo $Locations
	read -p "Please enter the line number of the correct directory listed above: "
fi

# fetch .ohmyzsh update from remote repo
	# this is a submodle that has been forked so might need to figure that out too

# pull Spacevim update
# pull update for this repo

