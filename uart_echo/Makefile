# Project setup
PROJ      = uart
BUILD     = ./build
DEVICE    = 1k
#DEVICE    = 8k
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

all:$(BUILD)/$(PROJ).bin

$(BUILD)/$(PROJ).blif: $(FILES) Makefile
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# synthesize using Yosys
	yosys -p "synth_ice40 -top top -blif $(BUILD)/$(PROJ).blif" $(FILES)

$(BUILD)/$(PROJ).asc: pinmap_$(FOOTPRINT).pcf $(BUILD)/$(PROJ).blif
	# Place and route using arachne
	arachne-pnr -d $(DEVICE) -P $(FOOTPRINT) -o $(BUILD)/$(PROJ).asc -p pinmap_$(FOOTPRINT).pcf $(BUILD)/$(PROJ).blif

$(BUILD)/$(PROJ).bin: $(BUILD)/$(PROJ).asc
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin

burn:   $(BUILD)/$(PROJ).bin
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

clean:
	rm -f build/* a.out
