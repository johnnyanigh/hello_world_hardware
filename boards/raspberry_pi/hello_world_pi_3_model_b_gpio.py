# Import the GPIO and other packages
import RPi.GPIO as GPIO
import time

# Print a message in the console
print("Hello, world from Raspberry Pi 3!")

GPIO.setmode(GPIO.BOARD)

# Drive GPIO4/BCM 4 (pin 7)
GPIO.setup(7, GPIO.OUT)

# Loop through 50 times to toggle the pin on/off for 1 second each
for i in range(50):
    GPIO.output(7, True)
    time.sleep(1)
    GPIO.output(7, False)
    time.sleep(1)

GPIO.cleanup()
