import RPi.GPIO as GPIO
import time
import os

# Setup button for GPIO
buttonPin2 = 23 
GPIO.setmode(GPIO.BCM)
GPIO.setup(buttonPin2, GPIO.IN, pull_up_down=GPIO.PUD_UP)

while True:
  GPIO.wait_for_edge(buttonPin2, GPIO.FALLING)
  print("Button 2 Pressed")
  os.system("/sbin/reboot")

GPIO.cleanup()
