#!/bin/bash

set -e

windowTitle="Zenity Window Focus"
windowText="Enter the process to be focused"
fieldSeparator="-->";
defaultWindowWidth=450

currentWindowNames=$(wmctrl -lp );
currentProcessNames=$(ps aux | grep -v grep );


function get_process_information {
	if [ -z "$1" ]
  	then
    	echo "PID not supplied";
    	return 1;
	fi

	windowName=$(echo "$currentWindowNames" | grep $1 | tr -s ' ' | cut -d' ' -f5-);
	processName=$(echo "$currentProcessNames" | grep $1 | grep -oE '[^ ]?+$')

    echo $windowName $fieldSeparator $processName;
    return 0;
}

for arg in "$@"; do
    shift
    case "$arg" in
    "--help") set -- "$@" "-h" ;;
    "--list") set -- "$@" "-l" ;;
    "--name") set -- "$@" "-n" ;;
    *) set -- "$@" "$arg" ;;
    esac
done

while getopts "nhlf" opt; do
    case "$opt" in
    "h")
        echo "Usage:"
        echo "    --help | -h            Display this help message."
        echo "    --list | -l            Generates the process GUI using a process suggestion list"
        echo "    --list | -l            Generates the GUI to get the name of the process which will have the focus"
        exit 0
        ;;
    "l")

        windowHeight=250
        windowWidth=600
 
        # Get the processes that have active GUI
        processList=$(wmctrl -lp | tr -s ' ' | cut -d' ' -f5-)
        processNames=$(echo "$processList" | sed 's/.* - //g')

        # Creates a list with the next format: 1 - The name of the process 2 - Information about the process
        parsedList=$(paste <(echo "$processNames") <(echo "$processList") -d "\n")

        processName=$(
            echo "$parsedList" |
                zenity --list \
                    --title="${windowTitle}" \
                    --text "${windowText}" \
                    --width="${windowWidth}" \
                    --height="${windowHeight}" \
                    --column="Process" \
                    --column="Information" \
                    --print-column=2
        )
        ;;
     "f")

        windowHeight=250
        windowWidth=600
         # Get the processes that have active GUI
         processList=$(wmctrl -lp | tr -s ' ' | cut -d' ' -f3 )

informationList='';

 while IFS= read -r pid; do
 	 processInformation=$(get_process_information $pid);
     informationList=$(printf "${informationList} \n ${processInformation}");
 done <<< "$processList"

  processName=$(
            echo "$informationList" | fzf | awk -F $fieldSeparator 'BEGIN {}{print $1}'
        );
 	;;
    "n")
        windowHeight=120
        windowWidth=250
        processName=$(
            zenity --entry \
                --title="${windowTitle}" \
                --text "${windowText}" \
                --width="${windowWidth}" \
                --height="${windowHeight}"
        )
        ;;
    esac
done

if [ -z "$processName" ]; then
    exit 0
fi

wmctrl -a $processName
