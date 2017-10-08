import RPi.GPIO as GPIO
import time
import os

# Setup button for GPIO
buttonPin3 = 24
GPIO.setmode(GPIO.BCM)
GPIO.setup(buttonPin3, GPIO.IN, pull_up_down=GPIO.PUD_UP)

while True:
  GPIO.wait_for_edge(buttonPin3, GPIO.FALLING)
  print("Button 3 Pressed")
  os.system("/sbin/poweroff")
GPIO.cleanup()
