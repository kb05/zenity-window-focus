#!/bin/bash

set -e;

processName=$(zenity --entry --title="zenity window focus" --text "Enter the process to change be focused");

if [ -z "$processName" ]; then
    exit 0;
fi

wmctrl -a $processName
