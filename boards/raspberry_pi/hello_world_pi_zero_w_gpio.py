#import the GPIO and time package
import RPi.GPIO as GPIO
import time

# Print message in the console
print("Hello, world from Raspberry Pi Zero W!")

GPIO.setmode(GPIO.BOARD)

# Drive GPIO4 (pin 7)
GPIO.setup(7, GPIO.OUT)

# loop through 50 times, on/off for 1 second
for i in range(50):
    GPIO.output(7,True)
    time.sleep(1)
    GPIO.output(7,False)
    time.sleep(1)

GPIO.cleanup()