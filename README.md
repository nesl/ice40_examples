# ICE40 HX8K Example Projects
This repository contains example projects targeting the Lattice ICE40 HX8K FGPA and the IceStorm open-source synthesis toolchain.

## Installing the required tools
The projects in this repository include a Makefile for easy compilation of the verilog and downloading of the bitstream to the FPGA. This Makefile depends on the open source IceStorm toolchain described at http://www.clifford.at/icestorm/. Instructions are provided at the previous address for installation of this toolchain for Mac OSX and Linux systems, but we have copied and expanded on these instructions here for convenience. For those unfamiliar with terminal programs, we recommend taking a look at basic commands for Bash like those described here: https://whatbox.ca/wiki/Bash_Shell_Commands. 

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

Finally, create the file /etc/udev/rules.d/53-lattice-ftdi.rules with the following line in it. This will enable permissions for writing bitstreams to Lattice FPGA devices as a priveleged user:
```
ACTION=="add", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", MODE:="666"
```

### Installation on OSX
Installation on Mac OSX is most easily achieved using Brew. If you have not installed Brew previously, follow the instructions here: http://brew.sh/. After installing Brew, follow the following steps.

Install the dependencies
```
brew install bison
brew install gawk
brew install pkg-config
brew install git
brew install mercurial
brew install graphviz
brew install python
brew install python3
brew install libftdi0
```
Note: if pkg-config is already installed but producing errors, try `brew reinstall pkg-config`. As with Linux, the rest of the installation requires downloading several git repositories and compiling the source:

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

### Installation on Windows
The IceStorm toolchain is not supported on Windows operating systems. However, if you have a Windows computer (or any other operating system for which you are having difficulties installing the IceStorm toolchain), you may download a Xubuntu virtual machine image that we have created with the IceStorm toolchain pre-installed along with the example projects in this repository.  

Installing VirtualBox:
Follow the instructions here: https://www.virtualbox.org/ in order to install the free VirtualBox virtual machine software for your operating system of choice. 

Downloading the VM Image:
Download our pre-made virtual machine image here: URL STILL TO COME and then unzip the contents of the image into your Virtualbox images folder--e.g. for Mac, this folder is in ~/VirtualBox VMs/.

Start the virtual machine:
Start the VirtualBox software. The virtual machine should appear in the list on the left. Click this image to highlight it, and then click start to power up the virtual machine. The username for this machine is "developer" and the administrative password is "verilogisfun". A recent snapshot of this repository can be found on the desktop. 

## Installing the keypad
Several of these example projects use a simple membrane keypad that can be purchased from Adafruit here: https://www.adafruit.com/product/419 . For all projects in this repository, this keypad is attached so that pins 1 through 7 (when enumerated left to right as viewed from the top side of the keypad) connect to the following FGPA I/O pins in this order: J15  G14  K14  GND  K15  M16  N16. This will effectively disable row 4 of the keypad due to the unfortunate placing of the ground pins on the development board, meaning the keypad itself will only be able to recognize keys 1 through 9 and not '*', '0', or '#'.

Detailed instructions on connecting the keypad and information about buttons and keypad scanning can be found in the slides here:
https://www.dropbox.com/s/3qgiq0j6qj3910f/keypad_instructions.pdf?dl=0

## Downloading, compiling, and programming the example projects
In order to download this repository, type `git clone https://github.com/nesl/ice40_examples.git ice40_examples` on the command line. Within the repository you will find a GPL license file, this readme, and several different example project folders such as "blinky." Within a given project folder, you will see:
* top.v -- the highest level Verilog file, including all pin inputs (e.g. clocks and button lines) and outputs (e.g. LEDs)
* (other modules.v) -- any other required modules (e.g. UART transmitters) referenced in top.v
* pinmap.pcf -- the pin map file relating variable names referenced in top.v to physical I/O pins on the ICE40 HX8K. The syntax here is `set_io <wire_name> <physical pin name>`.  You can add the `--warn-no-port` option if you'd like the compiler to warn you if a specified pin does not exist on a given device.
* Makefile -- this is a typical Unix Makefile that dictates the synthesis and programming flow. For the example projects, this file provides two commands of interest: `make` and `make burn`. `make` will compile your verilog project into a binary bitstream, and `make burn` will download this bitstream onto your FPGA device through USB. 
* build/ -- this is a folder where all intermediate build files are stored -- e.g. netlists, ascii bitstream, binary bistream. 

In order to compile an example project, navigate to that directory on your terminal.  Type `make` to compile the project. When this finishes, type `make burn` to load the compiled binary onto your FPGA, provided it's connected over USB.

Note for OSX: If you are having difficulties programming a project onto the FPGA with `make burn`, see the section below on UART transmission under the UART project. 

## Example Projects List
### blinky
This is a simple project with a 32 bit 12 MHz counter. All 8 LEDs on the development board are used to illustrate binary counting on some of the higher bits in the counter. This is a good starting place to test that your Icestorm toolchain is up and running.

### button_nopullup
This project demonstrates the problem of floating input pins. One input pin is left floating (not pulled high or low with a resistor) and connected to one of the buttons on the 4x3 keypad. LED 1 is specified to toggle on each falling edge of the input from the keypad's first column. The LED will toggle non-deterministically due to its floating state.

### button_bounce
This project demonstrates the proper way to configure a pull-up resistor on the input pins from the keypad's columns. It also demonstrates another problem--that of "debouncing" input pins that are connected to user inputs like buttons. Pressing key [1] on the pad will toggle LED 1, but on occasion it will toggle more than once due to "bouncing" on the input line.  

### button_debounce
This project demonstrates one way of signal debouncing by using a timer. Now, keypad [1] controls LED 1 in a controlled fashion, and the input pin is properly pulled to a default high voltage, as well.

### fsm_simple
This project shows a simple Mealy FSM using buttons [1] and [2] from the keypad. LEDs 1 and 2 are used to indicate button presses, and LED 3 will light up upon detection of the button sequence "1211" and will turn off otherwise.

### uart_transmission
This project demonstrates a simple universal asynchronous receiver/transmitter (UART) state machine. This state machine is constructed as a Verilog module with a 1 byte input and a 1 bit transmit input signal. By default, the program will cycle through ascii numerical digits "0" through "9", or equivalently decimal values 48 to 57. Digits are printed over UART + FTDI converter to a screen on the host at a baud rate of 9600.  Note that in this example only the UART transmitter state machine is implemented, and no receive functionality is provided. In order to view the output, a terminal program should be installed.  

Viewing UART transmission on Linux:
The device virtual COM port will appear under /dev/ on Linux machines. Typically, the name will look something like /dev/tty.USBA or /dev/tty.USB1.  You can easiliy list possible devices connected by typing `ls /dev/tty.*`. There will be two possible devices -- one (typically the first one in the ordered pair, such as A or 1) for programming your FPGA, and one for UART communication. Call this second one DEVNAME, for example "/dev/tty.USB2". On Linux, you can view the output from the UART communication by issuing the command 
```
screen DEVNAME
```
where DEVNAME is as described above. For example, `screen /dev/tty.USB2`.

Viewing UART transmission on OSX:
The process for viewing UART transmission on Mac OSX is the same as that of Linux, with one caveat: The FTDI drivers required to translate USB to/from UART and SPI (the protocol used to load the bitstream onto the FPGA) sometimes fight against each other. The result of this is that you need to unload the FTDI driver in order to program the FPGA device and reload the driver if you want to receive communication over UART.  To see what FTDI drivers are currently running, issue the command `kextstat | grep FTDI`. If there is no output, no FTDI drivers are running and your program binaries can successfully be programmed onto your FPGA. If there is a driver listed, note the driver name, e.g. `com.apple.driver.AppleUSBFTDI`. In order to unload this driver, type `kextunload -b com.apple.driver.AppleUSBFTDI` and attempt to program the FPGA once more. If you have finished programming the FPGA and now want to view the UART transmission on the console, re-load the driver: e.g. `kextload -b com.apple.driver.AppleUSBFTDI`. As with Linux, you now want to find the device by typing `ls /dev/tty.*` and then using the `screen` command as before. 

Viewing UART transmission on Windows:
If on a Windows machine (for viewing purposes only--i.e. this does not apply if you are using a VM on a Windows host), you must download a serial console program such as Realterm: http://realterm.sourceforge.net/, following their instructions to set up a Serial port with 8 bits, no parity, 1 stop bit, and 9600 baud rate. 

