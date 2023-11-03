# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Source .profile
if [ -f /home/celeron55/.profile ]; then
    . /home/celeron55/.profile
fi

export MOSH_ESCAPE_KEY='~'

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

#
# Keep window title short so that it's useful in GNU screen also
# https://superuser.com/questions/84710/window-title-in-bash/1366261#1366261
# https://stackoverflow.com/questions/71459823/how-to-change-the-terminal-title-to-currently-running-process
# https://lists.gnu.org/archive/html/screen-users/2008-07/msg00016.html
#
# With this, you can use this in GNU screen:
# caption always "%{wK}%?%-Lw%?%{Kw}%n*%f %t%?(%u)%?%{wK}%?%+Lw%? %= %d.%m. %c "
#
function title {
    export WTITLE=$1
}
#PS1_old="$(echo $PS1 | sed -En 's/(.+)\\e](.+)/\1\\\\e]\2/g; s/(.+ )(.+)/\1\\n\2/p')";
PS1_old="$PS1" # A good PS1 is already set in /etc/bashrc
_PS1='\[\e]0;\w\a\]';_PS1+="$PS1_old";export PS1=$_PS1;
#_PS1='\[\e]0;$WTITLE: \w\a\]';_PS1+="$PS1_old";export PS1=$_PS1;
# A command to use in bash (shell) scripts, replaces
# the above function that is for a "~/.bashrc" file:
#export WTITLE="bash"
if [[ "$TERM" =~ screen.* ]]; then
	# Tell GNU screen what its internal window title should be for this terminal
	#PROMPT_COMMAND='echo -n -e "\033k${HOSTNAME}\033\\"'
	#PROMPT_COMMAND='echo -n -e "\033k${PWD}\033\\"'
	PROMPT_COMMAND='echo -n -e "\033k${PWD##*/}\033\\"'
fi
