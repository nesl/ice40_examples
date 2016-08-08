This bitstream lets the FPGA control the serial line
setting of the FTDI chip, which again is connected to 
the USB port. The iCE stick then behaves exactly like
a modem connected with an USB port and can be connected
to with a regular terminal emulator from any operating
system.

An important parameter are the number of characters
per second to be transmitted, i.e. BAUD. This example
sets this to 9600 - which is slow. Under Linux, you may
use the following commands to address the FPGA once the
bitstream was burnt to it:

  * sudo minicom -b 9600 -D /dev/ttyUSB1   # or alternatively
  * sudo screen /dev/ttyUSB1

If you need the 'sudo' depends on the permissions assigned
to the device.  The use of screen may sound surprising to
many. It is a multifunctional tool. To become
familar with it is however a very good investment and
highly encouraged. Minicom you leave with "CTRL-A x",
screen with "CTRL-A d".

Linux users may also run a small C program to perform the
I/O with the device, i.e. to prepare a subsequent embedding
of the device in programms running on the computer.
  
  * sudo ./host /dev/ttyUSB1 some text

To evaluate the reliability of the communication, e.g. in a
virtualised environment, we propose to use the here provided
'host' utility repeatedly. The "run2" target of the Makefile
for instance combines it with an invocation of "watch" for a
manual inspection.

The 'uart_echo' example was derived from the only writing
example 'uart_transmission' of Paul Martin after an idea
from Stefan Ziegenbalg at http://www.ztex.de/firmware-kit/example.e.html.
It was prepared by Steffen Möller and Ruben Undheim as a donation
to the ice40 example collection of Paul Martin under the 
same current or future license as the reminder of his code base.
