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
bistream was burnt to it:

  * minicom -b 9600 -D /dev/ttyUSB1   # or alternatively
  * screen /dev/ttyUSB1

The use of screen may sound surprising to many. To become
familar with it is however a very good investment and
highly encouraged. Minicom you leave with "CTRL-A x",
screen with "CTRL-A d".

The 'uart_echo' example was derived from the only writing
example 'uart_transmission' of Paul Martin after an idea
from Stefan Ziegenbalg at http://www.ztex.de/firmware-kit/example.e.html.
It was prepared by Steffen Möller and Ruben Undheim as a donation
to the ice40 example collection of Paul Martin under the 
same current or future license as the reminder of his code base.
