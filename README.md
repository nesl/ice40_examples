# ICE40 HX8K Example Projects
This repository contains example projects targeting the Lattice iCE40 HX8K FGPA the IceStorm open-source synthesis toolchain. The examples target the [iCE40-HX8K breakout board](http://www.latticesemi.com/en/Products/DevelopmentBoardsAndKits/iCE40HX8KBreakoutBoard.aspx) (part # ICE40HX8K-B-EVN). Additionally, the examples can be easily adapted for the cheaper [iCEstick Evaluation Kit](https://www.latticesemi.com/icestick) which has a smaller FPGA. Both these boards are available for purchase from Lattice's website as well as fromm major electronic parts vendors such as Digi-Key, Mouser, Newark etc.

## Installing the required tools
The projects in this repository include a Makefile for easy compilation of the verilog and downloading of the bitstream to the FPGA. This Makefile depends on the open source IceStorm toolchain described at http://www.clifford.at/icestorm/. Instructions are provided at the previous address for installation of this toolchain for Mac OSX and Linux systems, but we have copied and expanded on these instructions here for convenience. For those unfamiliar with terminal programs, we recommend taking a look at basic commands for Zsh (https://www.sitepoint.com/zsh-commands-plugins-aliases-tools/) or Bash (https://whatbox.ca/wiki/Bash_Shell_Commands). However, if you do not wish to install the tools natively or are on a Windows machine then we have also provided a Virtual Machine image with a Linux/Ubuntu installation that you can run using VirtualBox. Alternatively, while we have not tried it yet, you could download a binary release of the [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build).

### Installation on Linux
These instructions are for installation on Ubuntu 14.04 or later, and will install relative to /usr/local.

Installing prerequisites:
```
sudo apt-get install build-essential clang bison flex libreadline-dev \
                     gawk tcl-dev libffi-dev git mercurial graphviz   \
                     xdot pkg-config python python3 libftdi-dev screen \
                     qt5-default python3-dev libboost-all-dev cmake libeigen3-dev
```
Installing the IceStorm toolchain:
```
git clone https://github.com/YosysHQ/icestorm.git icestorm
cd icestorm
make
sudo make install
```

Installing NextPNR for place and route:
```
git clone https://github.com/YosysHQ/nextpnr nextpnr
cd nextpnr
cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local .
make -j$(nproc)
sudo make install
```

Note: As an alternative to NextPNR above, you could install the older Arachne-PNR for place and route:
```
git clone https://github.com/YosysHQ/arachne-pnr.git arachne-pnr

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
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0660", GROUP="plugdev", TAG+="uaccess"
```

***Notes for Archlinux:*** just install [icestorm-git](https://aur.archlinux.org/packages/icestorm-git/), [arachne-pnr-git](https://aur.archlinux.org/packages/arachne-pnr-git/) and [yosys-git](https://aur.archlinux.org/packages/yosys-git/) from the Arch User Repository (no need to follow the install instructions above).


### Installation on OSX

These instructions were tested on OS X 13.2.1 (Ventura) running on a MacBook Pro with Apple M1 Max processor.

Installation on Mac OSX is most easily achieved using the Brew package manager.

First make sure to install Xcode from Apple's Mac App Store (https://apps.apple.com/us/app/xcode/id497799835) and then its command line tools
```
xcode-select --install
```

If you have not installed Brew previously, follow the instructions here: http://brew.sh/.
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installing Brew, follow the following steps (these have been verified on OS X Ventura):

Install the dependencies
```
brew install bison gawk pkg-config git mercurial graphviz python python3 libftdi0 libffi tcl-tk \
  boost boost-python3 qt5 eigen libusb libusb-compat yosys
```

The rest of the installation requires downloading several git repositories and compiling the source:

Installing the IceStorm toolchain:
```
cd $HOME/local
git clone https://github.com/YosysHQ/icestorm.git icestorm
cd icestorm
make
make install PREFIX=$HOME/local
```
Installing NextPNR for place and route:
```
cd $HOME/local
git clone https://github.com/YosysHQ/nextpnr nextpnr
cd nextpnr
cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=$HOME/local .
make
make install
```
Note: As an alternative to NextPNR above, you could install the older Arachne-PNR for place and route:
```
cd $HOME/local
git clone https://github.com/YosysHQ/arachne-pnr.git arachne-pnr
cd arachne-pnr
make
make install PREFIX=$HOME/local
```

If successful, you will be able to compile any of the example projects in the current repository by navigating to the project folder and executing the command `make`.

### Installation on Windows
The IceStorm toolchain is not supported on Windows operating systems. However, you can still use the tools via a Virtual Machine as described in the next section.

## Using the tools via a Virtual Machine

if you have a Windows computer (or any other operating system for which you are having difficulties installing the IceStorm toolchain), you may download a Xubuntu virtual machine image that we have created with the IceStorm toolchain pre-installed along with the example projects in this repository.  

Installing VirtualBox:
Follow the instructions here: https://www.virtualbox.org/ in order to install the free VirtualBox virtual machine software for your operating system of choice. You must also install the VirtualBox extension pack, listed here: https://www.virtualbox.org/wiki/Downloads to ensure that the USB pass through to your FPGA works. 

Downloading the VM Image:
Download one the following pre-made virtual machine images here: 

* https://ucla.box.com/s/jrd58laojxagop5urewt6qawcrhzwzm5 (from April 2020: latest versions of all the tools and Ubuntu; needs testing; username = developer and password = Verilog==Fun!).
* https://ucla.box.com/s/fyapf4i4462b5od4ml5p057aljtvq2rx (from 2016: older versions of various tools and Ubuntu; been used extensively; username = developer and password = verilogisfun).

and then unzip the contents of the image into your Virtualbox images folder--e.g. for Mac, this folder is in ~/VirtualBox VMs/.

Start the virtual machine:
Start the VirtualBox software. The virtual machine should appear in the list on the left. Click this image to highlight it, and then click start to power up the virtual machine. The username and password depend on which version of the virtual machine your are using and are as noted above. A recent snapshot of this repository can be found on the desktop.

## USB Drivers

The FPGA boards uses a [FTDI2232H chip](https://www.ftdichip.com/Products/ICs/FT2232H.htm) to connect to USB. The software loads the bitstream into the FPGA via the SPI protocol using low level bit-banging through the USB. To make things work, depending on your OS, you may need to install [drivers from FTDI](https://www.ftdichip.com/FTDrivers.htm). For example, under Mac OS X Catalina one needs to install FTDI's [VCP Driver](https://www.ftdichip.com/Drivers/VCP.htm).

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

### blank
This project does not do anything functional, but it serves as a starting point for creating your own projects. For convenience, the 8 LED outputs and hardware clock inputs are defined.

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

#### Viewing UART transmission on Linux:

The device virtual COM port will appear under /dev/ on Linux machines. Typically, the name will look something like /dev/tty.USBA or /dev/tty.USB1 or /dev/ttyUSB0.  You can easiliy list possible devices connected by typing `ls /dev/tty.*`. There will be two possible devices -- one (typically the first one in the ordered pair, such as A or 1 or 0) for programming your FPGA, and one for UART communication. Call this second one DEVNAME, for example "/dev/tty.USB2" or /dev/ttyUSB1. On Linux, you can view the output from the UART communication by issuing the command 
```
screen DEVNAME
```
where DEVNAME is as described above. For example, `screen /dev/ttyUSB1`. Alternatively, you can use a serial terminal program with a GUI, such as [CoolTerm](https://freeware.the-meiers.org). However, if your running Linux under VirtualBox, it would be better if you used a terminal program on your host machine/OS.

If running the `screen` command (or the terminal application that you may be using) is unable to open the USB port because of permission problems, you would need to run them with administrative privileges, such as `sudo screen /dev/ttryUSB1`. Alternatively, on Ubuntu 18.04.x, you can add the user to the dialout group via the command `sudo usermod -a -G dialout $USER` so as to gain permission to open the USB port.

#### Viewing UART transmission on OSX:

The process for viewing UART transmission on Mac OSX is the same as that of Linux. For the OS X Catalina, once you install FTDI's VCP driver as explained earlier, then do 'echo /dev/tty.usbserial-\*' to find the two devices corresponding to the FPGA board, e.g. /dev/tty.usbserial-142100 and /dev/tty.usbserial-142101. The second one (/dev/tty.usbserial-142101 in the example) is the one which is being used here. Now using the command 'screen /dev/tty.usbserial-142101' or an app such as (Serial)[https://www.decisivetactics.com/products/serial/], (SerialTools)[https://apps.apple.com/us/app/serialtools/id611021963?mt=12], and (others)[https://pbxbook.com/other/mac-ser.html], one can look at the output.

For older versions of OS X there is a caveat: the FTDI drivers required to translate USB to/from UART and SPI (the protocol used to load the bitstream onto the FPGA) sometimes fight against each other. The result of this is that one needs to unload the FTDI driver in order to program the FPGA device and reload the driver if you want to receive communication over UART.  To see what FTDI drivers are currently running, issue the command `kextstat | grep FTDI`. If there is no output, no FTDI drivers are running and your program binaries can successfully be programmed onto your FPGA. If there is a driver listed, note the driver name, e.g. `com.apple.driver.AppleUSBFTDI`. In order to unload this driver, type `kextunload -b com.apple.driver.AppleUSBFTDI` and attempt to program the FPGA once more. If you have finished programming the FPGA and now want to view the UART transmission on the console, re-load the driver: e.g. `kextload -b com.apple.driver.AppleUSBFTDI`. As with Linux, you now want to find the device by typing `ls /dev/tty.usb*` and then using the `screen` command or one of the serial apps as described above.

#### Viewing UART transmission on Windows:

If on a Windows machine (for viewing purposes only--i.e. this does not apply if you are using a VM on a Windows host), you must download a serial console program such as Realterm: http://realterm.sourceforge.net/, following their instructions to set up a Serial port with 8 bits, no parity, 1 stop bit, and 9600 baud rate. 

## Project Design Process:
In order to create your own project, start by copying the template provided in the blank project folder.  The general design process looks like this:
1.  Write your top-level Verilog code in top.v. Any additional Verilog files required can be placed at the same level as top.v (in the project folder).

2.  Modify your Makefile: change `PROJ` to be your project name, and if any additional Verilog files are required, they should follow the `FILES = top.v` line, using the format `FILES += newfile.v` where `newfile.v` is the name of any additional Verilog file you have written. You can use this syntax for however many files you need. 

3.  Modify pinmap.pcf. If any pins are required other than the input clock and LEDs, add a line to the pinmap.pcf file using the format `set_io --warn-no-port <wire_name> <physical pin name>`.

4.  Compile your project by running `make` from the project directory

5.  If your project successfully compiles, connect your FPGA over USB and type `make burn` to program the binary to your FPGA. 
