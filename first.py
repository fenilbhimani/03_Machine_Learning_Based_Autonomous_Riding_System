import Jetson.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)
GPIO.setup(32,GPIO.OUT)
GPIO.setup(21,GPIO.OUT)
GPIO.setup(22,GPIO.OUT)
GPIO.setup(23,GPIO.OUT)
GPIO.setup(24,GPIO.OUT)


pwm = GPIO.PWM(32,50)

GPIO.output(21,GPIO.HIGH)
GPIO.output(22,GPIO.LOW)
GPIO.output(23,GPIO.HIGH)
GPIO.output(24,GPIO.LOW)

pwm.start(7.5)
time.sleep(5)
pwm.ChangeDutyCycle(5)
time.sleep(5)
pwm.ChangeDutyCycle(9)
time.sleep(5)
pwm.ChangeDutyCycle(7.5)
time.sleep(10)
pwm.ChangeDutyCycle(5)
time.sleep(5)
pwm.ChangeDutyCycle(9)
time.sleep(5)
pwm.ChangeDutyCycle(7.5)
time.sleep(10)

GPIO.output(21,GPIO.LOW)
GPIO.output(22,GPIO.LOW)
GPIO.output(23,GPIO.LOW)
GPIO.output(24,GPIO.LOW)

GPIO.cleanup()


