#!/usr/bin/python
import RPi.GPIO as GPIO
import sys, time

GPIO.setwarnings(False)
#circuit matches CamJam EduKit #2 Worksheet Two
GPIO.setmode(GPIO.BOARD) #use BCM numbering

ledRed= 11 #pin connection used
ledBlue= 18 #pin connection used
GPIO.setup(ledRed,GPIO.OUT)
GPIO.setup(ledBlue,GPIO.OUT)

GPIO.setup(31, GPIO.OUT)
GPIO.setup(33, GPIO.OUT)
GPIO.setup(35, GPIO.OUT)
GPIO.setup(37, GPIO.OUT)

commandlist=['OnR', 'OffR', 'OnB', 'OffB', 'OnBoth', 'OffBoth', 'FlashR', 'FlashB', 'FlashTwo','f','b','r','l']
#nexrt section checks args supplied and gives prompt if wrong or no args on command line
if len(sys.argv) < 2:
    print ("Syntax sudo python SetLed.py plus one of: OnR, OffR, OnB, OffB, OnBoth, OffBoth, FlashR, FlashB, FlashTwo,f,b,r,l")
elif sys.argv[1] not in commandlist:
    print ("Syntax sudo python SetLed.py plus one of: OnR, OffR, OnB, OffB, OnBoth, OffBoth, FlashR, FlashB, FlashTwo,f,b,r,l")

#--------------------
def forward():
    GPIO.output(31,1)
    GPIO.output(33,0)
    GPIO.output(35,1)
    GPIO.output(37,0)
    time.sleep(0.5)
    GPIO.output(31,0)
    GPIO.output(35,0)
def backward():
    GPIO.output(31,0)
    GPIO.output(33,1)
    GPIO.output(35,0)
    GPIO.output(37,1)
    time.sleep(0.5)
    GPIO.output(33,0)
    GPIO.output(37,0)
def right():
    GPIO.output(35,1)
    GPIO.output(37,0)
    time.sleep(0.5)
    GPIO.output(35,0)
def left():
    GPIO.output(31,1)
    GPIO.output(33,0)
    time.sleep(0.5)
    GPIO.output(31,0)
#--------------------

for eachArg in sys.argv:
    if eachArg == 'OnR':
        print ("Turn On Red")
        GPIO.output(ledRed,1)

    elif eachArg == 'OffR':
        print ("Turn Off Red")
        GPIO.output(ledRed,0)
    
    elif eachArg == 'f':
        print ("Move car forward")
        forward()
    
    elif eachArg == 'b':
        print ("Move car backward")
        backward()
    
    elif eachArg == 'r':
        print ("Turn car right")
        right()
    
    elif eachArg == 'l':
        print ("Turn car left")
        left()

    elif eachArg == 'FlashR':
        print ("Flash Red Led")
        GPIO.output(ledRed,0) #make sure ledRed off before flashes
        time.sleep(0.2)
        for x in range(0,5):
            GPIO.output(ledRed,1)
            time.sleep(0.2)
            GPIO.output(ledRed,0)
            time.sleep(0.2)

    elif eachArg == 'OnB':
        print ("Turn On Blue")
        GPIO.output(ledBlue,1)

    elif eachArg == 'OffB':
        print ("Turn Off Blue")
        GPIO.output(ledBlue,0)

    elif eachArg == 'FlashB':
        print ("Flash Blue Led")
        GPIO.output(ledBlue,0) #make sure ledRed off before flashes
        time.sleep(0.2)
        for x in range(0,5):
            GPIO.output(ledBlue,1)
            time.sleep(0.2)
            GPIO.output(ledBlue,0)
            time.sleep(0.2)

    elif eachArg == 'OnBoth':
        print ("Turn On Both")
        GPIO.output(ledRed,1)
        GPIO.output(ledBlue,1)

    #elif eachArg == 'OnBoth':
     #   print ("Turn On Both")
      #  GPIO.output(ledRed,1)
       # GPIO.output(ledBlue,1)

    elif eachArg == 'OffBoth':
        print ("Turn Off Both")
        GPIO.output(ledRed,0)
        GPIO.output(ledBlue,0)

    elif eachArg == 'FlashBoth':
        print ("Flash Both Leds")
        GPIO.output(ledRed,0) #make sure ledRed off before flashes
        GPIO.output(ledBlue,0) #make sure ledBlue off before flashes
        time.sleep(0.2)
        for x in range(0,5):
            GPIO.output(ledRed,1)
            GPIO.output(ledBlue,0)
            time.sleep(0.2)
            GPIO.output(ledRed,0)
            GPIO.output(ledBlue,1)
            time.sleep(0.2)
        GPIO.output(ledBlue,0) #reset ledBlue after flashing
    

