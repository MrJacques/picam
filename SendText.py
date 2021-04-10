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
SendText message to send on error

www.twilio.com/referral/ft9Jn1

"""

import argparse
import json
import logging
import re
import socket
import subprocess
import sys
import time
from threading import Thread
from typing import IO, AnyStr, TextIO

from twilio.rest import Client

# Set these after parsing args
twilio_sid = None
twilio_token = None
twilio_from_phone = None

parser = argparse.ArgumentParser(usage='%(prog)s message',
                                 description="Run a non-interactive command and send a text if there is an error")

parser.add_argument('-n', '--pretend',
                    action='store_true',
                    help='Do not actually send text')

parser.add_argument('-t', '--test',
                    action='store_true',
                    help='Use test credentials to send text.')

parser.add_argument('--loglevel',
                    choices=['critical', 'error', 'warning', 'info', 'debug'],
                    type=str.lower,
                    help='Set logging level. Example --loglevel debug')

parser.add_argument('message',
                    nargs=argparse.REMAINDER,
                    action = 'store',
                    type = str,
                    help=f'Message to send.')

parser.usage = parser.format_help()
args = parser.parse_args()

if args.loglevel:
    logging.basicConfig(level=args.loglevel.upper())
    logging.info(f"Logging set to {args.loglevel.upper()}")

# TODO make path settable from command line or environment
with open(r'picam.json') as f:
    data = json.load(f)

if args.test:
    # test credentials
    assert data['twilio']['test']['account_sid']
    assert data['twilio']['test']['auth_token']
    assert data['twilio']['test']['from_phone']

    twilio_sid = data['twilio']['test']['account_sid']
    twilio_token = data['twilio']['test']['auth_token']
    twilio_from_phone = data['twilio']['test']['test_from']
else:
    # live credentials
    assert data['twilio']['account_sid']
    assert data['twilio']['auth_token']
    assert data['twilio']['from_phone']

    twilio_sid = data['twilio']['account_sid']
    twilio_token = data['twilio']['auth_token']
    twilio_from_phone = data['twilio']['from_phone']

assert data['twilio']['to_phones']
twilio_to_phones = data['twilio']['to_phones']

twilio_client = Client(twilio_sid, twilio_token)

pretend_mode = args.pretend
message = " ".join(args.message) if args.message else None

if not message:
    parser.error("There must be a message")

error_code = 0

# replace \n but not \\n with newline
message = re.sub(r"(^|[^\\])(\\n)", "\\1\n", message)

if pretend_mode:
    print(f"\n\nTEXT that would be sent:\n{message}")
else:
    logging.info(f"\n\nTEXT that will be sent:\n{message}")
    for to_phone in twilio_to_phones:
        logging.info(f"Text to {to_phone}")
        twilio_client.messages.create(
            to=to_phone,
            from_=twilio_from_phone,
            body=message)
