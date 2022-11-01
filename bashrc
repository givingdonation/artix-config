##better ls, ls -al
alias l='ls -hF'
alias la='l -Al'

##remove recursive
alias rmre="rm -r"

##interactive mode, just in case
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

alias df="df -h"
alias du="du -h"

#change brightness
alias bright="xrandr --output eDP1 --brightness"

##run startx if login shell
if [ $0 == "-bash" ]; then
	exec startx
fi
