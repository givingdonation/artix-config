##better ls, ls -al
alias l='ls -hF'
alias la='l -Al'

##battery capacity, not used anymore
alias battcap='cat /sys/class/power_supply/BAT0/capacity*'

alias pm="sudo pacman"

##interactive mode, just in case
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

##ReMove Not in Interactive mode
alias rmre="rm -r"

alias df="df -h"
alias du="du -h"

#change brightness
alias bright="xrandr --output eDP1 --brightness"

##sometimes useful for connecting wifi, not used very much anymore
alias setwifi="sudo rfkill unblock all;iwctl station wlan0 connect"

##run startx if login shell
if [ $0 == "-bash" ]; then
	exec startx
fi
