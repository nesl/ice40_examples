# Project setup
PROJ      = uart
BUILD     = ./build

# This code is compatible with the devices
#  1k, short for iCE40 HX1K - the USB stick
#  8k, short for iCE40 HX8K - a small USB-connected development board
# Device-specific files are not overwritten, which which this Makefile
# looks just a bit uncomfortable at a first sight.

# Uncomment the the line that you want to build the firmware for
DEVICE    = 1k
#DEVICE    = 8k

####  nothing to configure below this line #####

# The FOOTPRINT describes what port of the FPGA are connected to what 
# feature on the chip. This depends on the device, so this Makefile
# knows how to configures this.

ifeq (8k,$(DEVICE))
FOOTPRINT = ct256
else
FOOTPRINT = tq144
endif
STICKTTY  = /dev/ttyUSB1

# Files
FILES  = top.v
FILES += uart_tx.v
FILES += uart_rx.v
FILES += uart_clock.v

FILEStest  = uart_clock.v
FILEStest += uart_clock_top.v

.PHONY: all clean burn

all:$(BUILD)/$(PROJ)_$(DEVICE).bin host


CFLAGS += -g
host: host.c Makefile
	$(CC) $(CFLAGS) -o host host.c

$(BUILD)/$(PROJ).blif: $(FILES) Makefile
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# synthesize using Yosys
	yosys -p "synth_ice40 -top top -blif $(BUILD)/$(PROJ).blif" $(FILES)

$(BUILD)/$(PROJ)_$(DEVICE).asc: pinmap_$(FOOTPRINT).pcf $(BUILD)/$(PROJ).blif
	# Place and route using arachne
	arachne-pnr -d $(DEVICE) -P $(FOOTPRINT) -o $(BUILD)/$(PROJ)_$(DEVICE).asc \
                    -p pinmap_$(FOOTPRINT).pcf $(BUILD)/$(PROJ).blif

$(BUILD)/$(PROJ)_$(DEVICE).bin: $(BUILD)/$(PROJ)_$(DEVICE).asc
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ)_$(DEVICE).asc $(BUILD)/$(PROJ)_$(DEVICE).bin

burn:   $(BUILD)/$(PROJ)_$(DEVICE).bin
	iceprog $<

iverilog: a.out
a.out:  $(FILES)
	iverilog $(FILES)


test:	$(BUILD)/$(PROJ)test.bin
$(BUILD)/$(PROJ)test.bin: Makefile $(FILEStest)
	iverilog $(FILEStest)
	mkdir -p $(BUILD)
	yosys -p "synth_ice40 -top uart_clock_top -blif $(BUILD)/$(PROJ)test.blif" $(FILEStest)
	arachne-pnr -d $(DEVICE) -P $(FOOTPRINT) -o $(BUILD)/$(PROJ)test.asc -p pinmap_$(FOOTPRINT).pcf $(BUILD)/$(PROJ)test.blif
	icepack $(BUILD)/$(PROJ)test.asc $(BUILD)/$(PROJ)test.bin

burntest:   $(BUILD)/$(PROJ)test.bin
	iceprog $<

run:
	sudo screen $(STICKTTY)

run2:	host
	watch -n 0.2 sudo ./host /dev/ttyUSB1 some almost german-like long word

clean:
	rm -f build/* a.out core
