import RPi.GPIO as GPIO
import time
import os

# Setup button for GPIO
buttonPin1 = 18
GPIO.setmode(GPIO.BCM)
GPIO.setup(buttonPin1, GPIO.IN, pull_up_down=GPIO.PUD_UP)

while True:
  GPIO.wait_for_edge(buttonPin1, GPIO.FALLING)
  print("Button 1 Pressed")
  os.system("/usr/bin/perl /home/pi/scripts/get_sysinfo.pl")

  GPIO.wait_for_edge(buttonPin1, GPIO.RISING)
  print("Button 1 Released") 
  os.system("/home/pi/scripts/sendKey Q")

GPIO.cleanup()
