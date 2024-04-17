#!/bin/bash

# Get location of folder
Location=$(find /usr/share -type d -name terminal-configs)

# todo
# If there are multiple locations ask user for input for correct one
#if (( $($Locations | wc -l) > 1 ))
#then
#	echo $Locations
#	read -p "Please enter the line number of the correct directory listed above: " index
#
#fi

# Update submodules
git pull --recures-submodules -C $Location

# link zsh-custom to .oh-my-zsh/custom
ln -s $Location/zsh-configs/* $Location/.oh-my-zsh/custom