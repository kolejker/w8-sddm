#!/bin/sh

# Disable the second screen
xrandr --output <SECOND_SCREEN_NAME> --off

# Run the greeter in test mode
sddm-greeter-qt6 --test-mode --theme .

# Re-enable the second screen
xrandr --output <SECOND_SCREEN_NAME> --auto
