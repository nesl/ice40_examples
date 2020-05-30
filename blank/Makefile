# Project setup
PROJ      = blank
BUILD     = ./build
DEVICE    = 1k
#DEVICE    = 8k
ifeq (8k,$(DEVICE))
FOOTPRINT = ct256
else
FOOTPRINT = tq144
endif

# Files
FILES = top_$(DEVICE).v

.PHONY: all clean burn

all:$(BUILD)/$(PROJ)_$(DEVICE).bin

$(BUILD)/$(PROJ)_$(DEVICE).bin: $(FILES) Makefile
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# synthesize using Yosys
	yosys -p "synth_ice40 -top top -blif $(BUILD)/$(PROJ).blif" $(FILES)
	# Place and route using arachne
	arachne-pnr -d $(DEVICE) -P $(FOOTPRINT) -o $(BUILD)/$(PROJ)_$(DEVICE).asc -p pinmap_$(FOOTPRINT).pcf $(BUILD)/$(PROJ).blif
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ)_$(DEVICE).asc $(BUILD)/$(PROJ)_$(DEVICE).bin

burn:   $(BUILD)/$(PROJ)_$(DEVICE).bin
	iceprog $<

clean:
	rm -f build/*
