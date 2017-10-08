#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H:%M")

fswebcam -r 960x720 --no-banner /home/pi/pics/$DATE.jpg

