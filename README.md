# ICE40 HX8K Example Projects
This repository contains example projects targeting the Lattice ICE40 HX8K FGPA and the Icestorm open-source synthesis toolchain.

## Installing the required tools
The projects in this repository include a Makefile for easy compilation of the verilog and downloading of the bitstream to the FPGA. This Makefile depends on the open source Icestorm toolchain described at http://www.clifford.at/icestorm/. Instructions are provided at the previous address for installation of this toolchain for Mac OSX and Linux systems, but we have copied and expanded on these instructions here for convenience. For those unfamiliar with terminal programs, we recommend taking a look at basic commands for Bash like those described here: https://whatbox.ca/wiki/Bash_Shell_Commands. 

### Installation on Linux
These instructions are for installation on Ubuntu 14.04 or later. 

Installing prerequisites:
```
sudo apt-get install build-essential clang bison flex libreadline-dev \
                     gawk tcl-dev libffi-dev git mercurial graphviz   \
                     xdot pkg-config python python3 libftdi-dev
```
Installing the IceStorm toolchain:
```
git clone https://github.com/cliffordwolf/icestorm.git icestorm
cd icestorm
make
sudo make install
```

Installing Arachne-PNR for place and route:

```
git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
cd arachne-pnr
make
sudo make install
```
Installing Yosys for Verilog synthesis:
```
git clone https://github.com/cliffordwolf/yosys.git yosys
cd yosys
make
sudo make install
```

If successful, you will be able to compile any of the example projects by navigating to the project folder and executing the command `make`.

### Installation on OSX

### Installation on Windows

## Installing the keypad
Several of these example projects use a simple membrane keypad that can be purchased from Adafruit here: https://www.adafruit.com/product/419 . For all projects in this repository, this keypad is attached so that pins 1 through 7 (when enumerated left to right as viewed from the top side of the keypad) connect to the following FGPA I/O pins in this order: J15  G14  K14  GND  K15  M16  N16. This will effectively disable row 4 of the keypad due to the unfortunate placing of the ground pins on the development board, meaning the keypad itself will only be able to recognize keys 1 through 9 and not '*', '0', or '#'.

## Example Projects
### blinky
This is a simple project with a 32 bit 12 MHz counter. All 8 LEDs on the development board are used to illustrate binary counting on some of the higher bits in the counter. This is a good starting place to test that your Icestorm toolchain is up and running. On Unix systems, the project can be compiled by typing "make" and programmed by typing "make burn."

### button_nopullup
This project demonstrates the problem of floating input pins. One input pin is left floating (not pulled high or low with a resistor) and connected to one of the buttons on the 4x3 keypad. LED 1 is specified to toggle on each falling edge of the input from the keypad's first column. The LED will toggle non-deterministically due to its floating state. On Unix systems, the project can be compiled by typing "make" and programmed by typing "make burn."

### button_bounce
This project demonstrates the proper way to configure a pull-up resistor on the input pins from the keypad's 3 columns. It also demonstrates another problem--that of "debouncing" input pins that are connected to user inputs like buttons. Pressing key [1] on the pad will toggle LED 1, but on occasion it will toggle more than once due to "bouncing" on the input line.  On Unix systems, the project can be compiled by typing "make" and programmed by typing "make burn."

### button_debounce
This project demonstrates one way of signal debouncing by using a timer. Now, keypad [1] controls LED 1 in a controlled fashion, and the input pin is properly pulled to a default high voltage, as well.  On Unix systems, the project can be compiled by typing "make" and programmed by typing "make burn."

### fsm_simple
This project shows a simple Mealy FSM using buttons [1] and [2] from the keypad. LEDs 1 and 2 are used to indicate button presses, and LED 3 will light up upon detection of the button sequence "1211." On Unix systems, the project can be compiled by typing "make" and programmed by typing "make burn."

### uart_transmission
This project demonstrates a simple universal asynchronous receiver/transmitter (UART) state machine. This state machine is constructed as a Verilog module with a 1 byte input and a 1 bit transmit input signal. By default, the program will cycle through ascii numerical digits "0" through "9", or equivalently decimal values 48 to 57. Digits are printed over UART + FTDI converter to a screen on the host at full speed, 9600 baud rate. In order to view the output, a terminal program should be installed.  For example, screen, minicom, terraterm, realterm, etc. Note that two different tty / COM ports will show up: one for the programming of the FPGA flash and one for the UART transmission. On Unix systems, the project can be compiled by typing "make" and programmed by typing "make burn."

#### Special note for OSX users: 
The FTDI drivers required to view the communication from the FPGA on a terminal can sometimes fight against the drivers used in Icestorm to program the FPGA flash. If this is causing a problem, you can:
* Unload the FTDI driver in order to program your FPGA. In a terminal console, use "kextstat | grep FTDI" to see if the FTDI driver is running. An example output might show that "com.apple.driver.AppleUSBFTDI" is running, or that "com.FTDI.driver.FTDIUSBSerialDriver" is running. Unload whichever one is running on your system by typing "sudo kextunload -b <yourdriver>" where <yourdriver" is, e.g., "com.FTDI.driver.FTDIUSBSerialDriver" or whatever else is listed on your computer. In order to receive UART data from your FPGA again, you'll need to re-load the driver using "sudo kextload -b <yourdriver>".
