#!/usr/bin/python
#
#  Copyright (c) 2021.  Jacques Parker
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of
# the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
# THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#  MIT License  copyright@judyandjacques.com

"""
Compare the LDR to the LDR_THRESHOLD and switch on or off the IR filter.

You will need to tune the LDR_THRESHOLD

"""

import logging
import RPi.GPIO as GPIO
import time

# This sets the root logger to write to stdout (your console)
logging.basicConfig(level=logging.DEBUG)

# define the pins and other constants
LDR_PIN = 7
MODE_PIN = 13

DAY_MODE = GPIO.HIGH
NIGHT_MODE = GPIO.LOW

MAIN_LOOP_DELAY = 15
VERIFY_LOOP_DELAY = 2  # Seconds
VERIFY_LOOP_COUNT = 5
LDR_THRESHOLD = 100000

GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)

current_mode = None


def ldr_strength():
    # Output on the pin for
    GPIO.setup(LDR_PIN, GPIO.OUT)
    GPIO.output(LDR_PIN, GPIO.LOW)
    time.sleep(0.1)

    # Change the pin back to input
    start_time = time.time()
    GPIO.setup(LDR_PIN, GPIO.IN)

    # Wait until the pin goes high
    while GPIO.input(LDR_PIN) == GPIO.LOW:
        time.sleep(0.01)
        # TODO Add timeout check

    delta = (time.time() - start_time) * 1000000

    logging.debug('ldr_strength: %s' % delta)
    return delta


def ldr_mode():
    mode_value = NIGHT_MODE
    if ldr_strength() < LDR_THRESHOLD:
        mode_value = DAY_MODE
    return mode_value


def set_mode(new_mode):
    GPIO.setup(MODE_PIN, GPIO.OUT)
    GPIO.output(MODE_PIN, new_mode)
    logging.info('Set mode ' + mode(new_mode))


def mode(m):
    if m == DAY_MODE:
        return 'DAY'
    if m == NIGHT_MODE:
        return 'NIGHT'
    if m is None:
        return 'None'
    return 'UNKNOWN'


# Catch when script is interrupted, cleanup correctly
logging.info('Started')
try:
    # Main loop
    current_mode = None
    while True:
        time.sleep(MAIN_LOOP_DELAY)
        tested_mode = ldr_mode()

        if (current_mode is None) or (current_mode != tested_mode):
            logging.debug('Initial test: Current %s, Tested %s', mode(current_mode), mode(tested_mode))
            day_count = 0
            for i in range(1, VERIFY_LOOP_COUNT):
                time.sleep(VERIFY_LOOP_DELAY)
                if ldr_mode() == DAY_MODE:
                    day_count += 1

            verified_mode = NIGHT_MODE
            if day_count * 2 > VERIFY_LOOP_COUNT:
                verified_mode = DAY_MODE

            logging.debug('Verified: %s' % mode(verified_mode))
            if (current_mode is None) or (current_mode != verified_mode):
                logging.info('Mode Change to %s' % mode(verified_mode))
                set_mode(verified_mode)
                current_mode = verified_mode
except KeyboardInterrupt:
    pass
finally:
    GPIO.cleanup()
    logging.info('Exiting')
