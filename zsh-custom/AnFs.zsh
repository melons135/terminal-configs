## Aliases

#internet QOL
alias www="firefox -url $1 &"

#git QOL things
alias gitgraph="git log --all --graph --decorate"

#copy to clipboard
alias clip='xclip -selection clipboard'

#to work with tar.gz files
alias untar="tar -xvf $@"
alias viewtar="tar -tvf $@"

#reload zsh
alias reload='source ~/.zshrc'

#Dockers
#rustscan in docker - This is not good, its needs a -- -A for nmap commands but only works if -a is used to specify the address
alias rustscan='sudo docker run -it --rm --name rustscan rustscan/rustscan:latest -b 1500 -a'

#Spin-up docker
alias dockerit='sudo docker run -it --rm -v $PWD:/host --entrypoint=/bin/bash $2'

#Python2 - install requests and packages with `sh -c "pip install requests && python script.py ...` in place of final `python`
alias python2='docker run -it -v $(pwd):/host -w /host python:2 python'

# docker here
alias dockerit='docker run -it --rm -v $(pwd):/host $2'

# Bloodhound
alias bloodhound='xhost + && sudo docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix -e DISPLAY=$DISPLAY --network host --name bloodhound bannsec/bloodhound'

#torify proxy
alias hide='if [ `systemctl is-active` = 'inactive'] ; do systemctl start tor ;fi ; source torsocks on'
alias unhide='source torsocks off'
# or
# alias hide='source torsocks on'
# alias unhide='source torsocks off'

#network help
alias listening='ss -nlt'

#colour commands
alias ip="ip -c"

#list all IPs breif
alias ips="ip -c=never -brie a"

# Batcat alias
alias bat="batcat"

# Quick resurect tmux session
alias mux='pgrep -vx tmux > /dev/null && \
		tmux new -d -s delete-me && \
		tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh && \
		tmux kill-session -t delete-me && \
		tmux attach || tmux attach'

# Organise process output
alias ps='ps -faux'

# Cape execution with ruleset
alias cape='capa -r /opt/capa-rules'

# Back to previous directory
alias back=popd

## Functions
#make a directory and move into it
mk() {
	mkdir $1
	cd $1
}

#start python server
server(){
	PORT=$(($RANDOM+1024))
	echo 'Server address has been copied to your clipboard, if a file was listed after this has also been copied. A file can be added as an argument, this will be also added to URI that has been coppied'
	ADDRESS="http://$(hostname -I | awk '{print $1}'):$PORT"
	xclip -selection clipboard $ADDRESS/$1
	echo "The server is being hosted on $ADDRESS, the files in this directory are:"
	ls $PWD
	python3 -m http.server $PORT &>/dev/null
}

#fast scan and output
## OLD: sudo docker run -it -v $PWD:/nmap --rm --name rustscan rustscan/rustscan:latest rustscan $1 -- -A -oN /nmap/nmap.txt -oX /nmap/nmap.xml && searchsploit -v --nmap nmap.xml --exclude="/dos/" | tee "searchsploit.txt" && rm nmap.xml
## OLD2: nmap -Pn $1 -oN nmap/quick-$1.txt && nmap -Pn -p- -T4 -A -oN nmap/full-$1.txt -oX nmap/nmap.xml $1 && searchsploit -v --nmap nmap/nmap.xml --exclude="/dos/" | tee "nmap/searchsploit.txt" && rm nmap/nmap.xml
function scan(){
	mkdir nmap || true
	nmap -Pn $1 -oN nmap/quick-$1.txt
	sudo nmap -Pn -sU -oN nmap/UDP-$1.txt
	ports=$(nmap -Pn -p- -T4 $1 | grep '^[0-9]' | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
	nmap -p$ports -sC -sV -oN nmap/full-$1.txt -oX nmap/nmap.xml $1
	searchsploit -v --nmap nmap/nmap.xml --exclude="/dos/i" | tee "nmap/searchsploit.txt"
	rm nmap/nmap.xml
}

# SMBeagle
function smbeagle(){
  if [ -z $1 ]; then
    read -p 'List network CIDR (space seperated): ' networks
  else
    $@=networks
  fi
  read -p 'To use crednetials, please list the username and password in the following format (-u <USERNAME> -p <PASSWORD>): ' creds
  sudo docker run -v "./output:/tmp/output" punksecurity/smbeagle -c /tmp/output/results.csv -n $networks $creds
}

# this might not work due to command order (path called before fuctions)
function diff(){
	if ! command -v diff-so-fancy &> /dev/null
	then
		diff $"@" | diff-so-fancy
	else
		diff $"@"
fi
}

#backup file
function backup(){
  sudo cp $(realpath $1){,.bak}
}

# Compare 2 strings
compare(){
	if [[ ! $( diff <(echo $1) <(echo $2)) ]]; then echo Match; else diff <(echo $1) <(echo $2); fi
}

OS=$(grep ^NAME= /etc/os-release | awk -F '"' '{print $2}')
update(){
	case $OS in
		'Ubuntu' | 'Kali Linux')
			sudo apt update && sudo apt upgrade
			;;
		'Arch Linux')
			sudo pacman -Syu
			;;
		'Red Hat Enterprise Linux')
			sudo yum update -y
			;;
		'Alpine Linux')
			sudo apk update -y
			;;	
		*)
			echo 'This function has not registered the NAME value in the file etc/os-release'
			;;
	esac
}

websploit(){
	if ! test -f /usr/share/Websploit/docker-compose.yml; then
		echo "getting docker-compose.yml from WebSploit.org"
		mkdir -p /usr/share/Websploit && wget -O /usr/share/Websploit/docker-compose.yml https://websploit.org/docker-compose.yml
	fi
	# exit early on non 0 status
	echo "Setting up the containers and internal bridge network"
	(set -e
	docker-compose -f /usr/share/Websploit/docker-compose.yml up -d
	clear
	echo -e "\n\e[96mWebSploit\e[39m
	by Omar Santos @santosomar
	-------------------------------------
	Internal Hacking Networks: 10.6.6.0/24 and 10.7.7.0/24
	Your bridge networks:" && ip -c -brie a | grep 10.6.6.1 && ip -c -brie a | grep 10.7.7.1 && echo -e "
	The following are the WebSploit vulnerable containers and associated IP addresses.
	+------------------------+------------+
	|     Container          | IP Address |
	+------------------------+------------+
	| webgoat                |  10.6.6.11 |
	| juice-shop             |  10.6.6.12 |
	| dvwa                   |  10.6.6.13 |
	| mutillidae_2           |  10.6.6.14 |
	| dvna                   |  10.6.6.15 |
	| hackazon               |  10.6.6.16 |
	| hackme-rtov            |  10.6.6.17 |
	| mayhem                 |  10.6.6.18 |
	| rtv-safemode           |  10.6.6.19 |
	| galactic-archives      |  10.6.6.20 |
	| yascon-hackme          |  10.6.6.21 |
	| secretcorp-branch1     |  10.6.6.22 |
	| gravemind              |  10.6.6.23 |
	| dc30_01                |  10.6.6.24 |
	| dc30_01                |  10.6.6.25 |
	| y-wing                 |  10.6.6.26 |
	| dc31_01                |  10.7.7.21 |
	| dc31_02                |  10.7.7.22 |
	| dc31_03                |  10.7.7.23 |
	+------------------------+------------+ "
	echo -e "The following are the \e[92mrunning \e[39mcontainers with their associated ports:"
	docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}")
}
