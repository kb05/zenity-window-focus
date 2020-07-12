# zenity-window-focus
A simple Graphic UI that allows change the window that has the focus using zenity.

How works?

the command currently has two modes, --list | -l and --name |-n


## -- list :

1. Zenity extract the current process that have a GUI instance (using wmctrl).
2. The user choice the process that want have the window focus.
2. Use wmctrl to change the focus.
<img src="https://raw.githubusercontent.com/kb05/zenity-window-focus/master/images/zenity-window-focus-list.gif" width="700" height="350">


## -- name :

1. Zenity creates a field input where you should enter the name of the process that you want to have the screen focus.
2. The user write the name of process that want have the window focus.
3. Use wmctrl to change the focus

<img src="https://raw.githubusercontent.com/kb05/zenity-window-focus/master/images/zenity-window-focus-name.gif" width="700" height="350">
