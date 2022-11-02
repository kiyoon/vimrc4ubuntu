#!/bin/bash

# Example output:
# 0 bash display_screen_window_commands.sh
# 1 /home/kiyoon/miniconda3/bin/python /home/kiyoon/miniconda3/bin/ipython
# 2 vi a.py
# 4 vi b.py

# Note that some windows can be idle, and then it won't print anything.

# Update for Windows WSL:
# w command does not print anything on WSL. So we read from environment variable $WINDOW instead of reading the actual screen window number.
# This can be inaccurate when user changed the number.

if [[ ! -z $STY ]]
then
	session_pid=$(echo "$STY" | awk -F. '{print $1}')
	windows_procs=$(ps -el | awk "\$5==$session_pid")

	while read windows_proc 
	do
		windows_pid=$(echo "$windows_proc" | awk '{print $4}')
		# windows_pts=$(echo "$windows_proc" | awk '{print $12}')
		command_pid=$(ps -el | awk "\$5==$windows_pid" | awk '{print $4}')
		if [[ ! -z $command_pid ]]	# sometimes no command is running
		then
			full_command=$(ps --no-headers -u -p $command_pid | awk '{for(i=11;i<=NF;++i)printf $i" "}' )
			# Accurate, but needs `w` command to work. Windows WSL doesn't have this.
			# window_index=$(w -h | awk '$2=="'"$windows_pts"'"' | awk '{print $3}' | awk -F ':S.' '{print $2}')
			# Read from the environment variable.
			window_index=$(strings /proc/$windows_pid/environ | grep ^WINDOW= | awk -F= '{print $2}')
			echo "$window_index $full_command"
		fi
	done <<< "$windows_procs"
fi

