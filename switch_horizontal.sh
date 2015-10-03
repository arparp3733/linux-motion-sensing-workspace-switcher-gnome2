`pacman -Qs wmctrl > /dev/null`
if [ $? -eq 0 ]
then
	COUNTER=0
	while [  $COUNTER -lt 100 ]
	do
	    sleep 1
	    INFO=`wmctrl -d`
	    WIDTH=` xdpyinfo | grep dimensions | cut -d'p' -f1 | cut -d' ' -f7 | cut -d'x' -f1`
	    HEIGHT=` xdpyinfo | grep dimensions | cut -d'p' -f1 | cut -d' ' -f7 | cut -d'x' -f2`
	    TOTALWIDTH=` wmctrl -d | cut -d':' -f2 | cut -d' ' -f2 | cut -d'x' -f1`
		TOTALHEIGHT=` wmctrl -d | cut -d':' -f2 | cut -d' ' -f2 | cut -d'x' -f2`
		NO_OF_ROWS=$[$TOTALHEIGHT/$HEIGHT]
		NO_OF_COLS=$[$TOTALWIDTH/$WIDTH]
		NO_OF_WORKSPACES=$[$NO_OF_ROWS*$NO_OF_COLS]
		COORD1=`wmctrl -d | cut -d'P' -f2 | cut -d':' -f2 | cut -d'W' -f1 | cut -d' ' -f2 | cut -d',' -f1`
		COORD2=`wmctrl -d | cut -d'P' -f2 | cut -d':' -f2 | cut -d'W' -f1 | cut -d' ' -f2 | cut -d',' -f2`
		WORKSPACE_INDEX=$(echo $[$[$[$COORD2/$HEIGHT]*$NO_OF_COLS]+$[$COORD1/$WIDTH]])
		HPOS=`cat /sys/devices/platform/lis3lv02d/position | cut -d',' -f1 | cut -d'(' -f2`
		if [ $HPOS -ge 200 ]
			then
			let WORKSPACE_INDEX=WORKSPACE_INDEX+1
			WORKSPACE_INDEX=$(echo $[$[$[$WORKSPACE_INDEX%$NO_OF_WORKSPACES]+$NO_OF_WORKSPACES]%$NO_OF_WORKSPACES])
			ROW=$(echo $[$WORKSPACE_INDEX/$NO_OF_COLS])
			COL=$(echo $[$WORKSPACE_INDEX%$NO_OF_COLS])
			ROWPX=$(echo $[$ROW*$HEIGHT])
			COLPX=$(echo $[$COL*$WIDTH])
			`wmctrl -o $COLPX,$ROWPX`
		elif [ $HPOS -le -200 ]
			then
			let WORKSPACE_INDEX=WORKSPACE_INDEX-1
			WORKSPACE_INDEX=$(echo $[$[$[$WORKSPACE_INDEX%$NO_OF_WORKSPACES]+$NO_OF_WORKSPACES]%$NO_OF_WORKSPACES])
			ROW=$(echo $[$WORKSPACE_INDEX/$NO_OF_COLS])
			COL=$(echo $[$WORKSPACE_INDEX%$NO_OF_COLS])
			ROWPX=$(echo $[$ROW*$HEIGHT])
			COLPX=$(echo $[$COL*$WIDTH])
			`wmctrl -o $COLPX,$ROWPX`
		fi
		let COUNTER=COUNTER+1
	done

else
	echo "Package wmctrl is required."
	echo "It is not installed on your system."
	echo "Do you want to install the package and run the script(y/n)?"
	read INSTALL_CHOICE
	if [ $INSTALL_CHOICE = "y" || $INSTALL_CHOICE = "Y" ]
	then
		sudo pacman -S wmctrl
	else
		echo "Thank you for trying  my script."
	fi
fi
