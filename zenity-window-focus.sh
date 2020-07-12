#!/bin/bash

set -e

windowTitle="Zenity Window Focus"
windowText="Enter the process to be focused"

defaultWindowWidth=450

for arg in "$@"; do
    shift
    case "$arg" in
    "--help") set -- "$@" "-h" ;;
    "--list") set -- "$@" "-l" ;;
    "--name") set -- "$@" "-n" ;;
    *) set -- "$@" "$arg" ;;
    esac
done

while getopts "nhl" opt; do
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
                    --column="asddsa" \
                    --column="Information" \
                    --print-column=2
        )
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
