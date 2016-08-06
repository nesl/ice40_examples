This bitstream lets the FPGA control the serial line
setting of the FTDI chip, which again is connected to 
the USB port. The iCE stick then behaves exactly like
a modem connected with an USB port and can be connected
to with a regular terminal program.

An important parameter are the number of characters
per second to be transmitted, i.e. BAUD. This example
sets this to 9600 - which is slow. Use the following
commands to adress the FPGA:

Linux:

  * minicom -b 9600 -D /dev/ttyUSB1   # or alternatively
  * screen /dev/ttyUSB1

  We observed fewer issues with screen wrt to forwarding
  input from the keyboard.
