# Configure human input devices



#instead of: xinput set-button-map "2.4G Wireless Optical Mouse" 1 2 3 4 5 6 7 0 
Section "InputClass"
    Identifier  "2.4G Wireless Optical Mouse"
    Option  "ButtonMapping" "1 2 3 4 5 6 7 0 0 10 11 12 13 14 15 16"
EndSection


# The buttons on the BT receiver double as volume up/down and prev/next track. This disables the prev/next functions.
xinput float 'RX-TX-10 (AVRCP)'

