# udev

# Troubleshooting udev rules, etc.


#udevadm monitor

# Trace udev execution of rules
#udevadm control --log-priority=debug
#journalctl -f

# unix.stackexchange.com/a/39371/44760
# $ udevadm test
# $ validated rules against reality
# $ udevadm info
#

# Use udevadm monitor -u, udevadm test ... and udevadm trigger ... to verify which rules processed the events.

# Very useful. A couple of comments udevadm test... appears to only show you environment variables, to gets ATTRS you can use udevadm info $DEVICE to find these other settings.

