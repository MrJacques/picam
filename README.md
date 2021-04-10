# picam
Water proof pi zero based camera

#TODO Finish and turn into english.

Instructions

1) Build LDR circuit using pin 7 for the LDR (Yellow wire below).  This will allow you to use the ambient light level to switch on the camera IR filter.  The IR LEDs have their own adjustable sensors.

2) Soldier header to IR Mode Pin on camera.  This goes to Raspberry Pi pin 13.  This will allow the Camera’s IR filter to be controlled by the Raspberry Pi.

3) Install MotionEye on Raspberry Pi

4) Copy python scripts to /data directory.  Add execute bit to scripts (chmod +x *.py)

5) I’ve used the Twilio API to implement the texting.

You can get a free trial account at www.twilio.com/referral/ft9Jn1

That includes my referral code with Twilio which will earn me some free text if you end up paying for an account.

Once you sign up, rename the picam-sample.json to picam.json and then edit with your information. The phones you want to send to will need to be authorized on Twilio.

Install the twilio python package: sudo python -m pip install twilio

6) Print the Raspberry pi camera.scad and Raspberry pi cones.scad.  

The purple post is meant as a holder for the LDR circuit and can be removed if not needed.

The cones are meant to reduce glare and IR reflection.  The should be adjusted so they are touching the inside of the case.

7) Assemble without power.  This will allow you to plan out where you want to drill a hole for the raspberry pi usb power cord.  Seal with Silicone.




